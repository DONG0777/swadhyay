create extension if not exists postgis with schema extensions;

alter table public.community_places
  add column if not exists location extensions.geography(POINT, 4326);

create index if not exists community_places_location_gist_idx
  on public.community_places
  using gist (location);

create or replace function public.set_community_place_location(
  p_place_id uuid,
  p_latitude double precision,
  p_longitude double precision
)
returns public.community_places
language plpgsql
security definer
set search_path = public, extensions
as $function$
declare
  v_place public.community_places;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if p_latitude < -90 or p_latitude > 90 then
    raise exception 'Latitude must be between -90 and 90.';
  end if;

  if p_longitude < -180 or p_longitude > 180 then
    raise exception 'Longitude must be between -180 and 180.';
  end if;

  update public.community_places
  set location = extensions.st_setsrid(
    extensions.st_makepoint(
      p_longitude,
      p_latitude
    ),
    4326
  )::extensions.geography
  where id = p_place_id
    and created_by = auth.uid()
  returning * into v_place;

  if not found then
    raise exception 'Community place not found or not owned by current user.';
  end if;

  return v_place;
end;
$function$;

revoke all
on function public.set_community_place_location(
  uuid,
  double precision,
  double precision
)
from public;

grant execute
on function public.set_community_place_location(
  uuid,
  double precision,
  double precision
)
to authenticated;

create or replace function public.find_nearby_community_places(
  p_latitude double precision,
  p_longitude double precision,
  p_radius_meters double precision default 5000,
  p_limit integer default 30
)
returns table (
  id uuid,
  name text,
  description text,
  address text,
  timezone text,
  distance_meters double precision
)
language sql
security definer
set search_path = public, extensions
as $function$
  select
    cp.id,
    cp.name,
    cp.description,
    cp.address,
    cp.timezone,
    extensions.st_distance(
      cp.location,
      extensions.st_setsrid(
        extensions.st_makepoint(
          p_longitude,
          p_latitude
        ),
        4326
      )::extensions.geography
    ) as distance_meters
  from public.community_places cp
  where cp.location is not null
    and p_radius_meters > 0
    and p_radius_meters <= 50000
    and p_limit > 0
    and p_limit <= 100
    and extensions.st_dwithin(
      cp.location,
      extensions.st_setsrid(
        extensions.st_makepoint(
          p_longitude,
          p_latitude
        ),
        4326
      )::extensions.geography,
      p_radius_meters
    )
  order by
    cp.location operator(extensions.<->)
      extensions.st_setsrid(
        extensions.st_makepoint(
          p_longitude,
          p_latitude
        ),
        4326
      )::extensions.geography
  limit p_limit;
$function$;

revoke all
on function public.find_nearby_community_places(
  double precision,
  double precision,
  double precision,
  integer
)
from public;

grant execute
on function public.find_nearby_community_places(
  double precision,
  double precision,
  double precision,
  integer
)
to authenticated;
