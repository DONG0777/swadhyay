create or replace function public.create_community_session(
  p_place_id uuid,
  p_title text,
  p_description text,
  p_location_name text,
  p_location_details text,
  p_starts_at timestamptz,
  p_ends_at timestamptz,
  p_capacity integer
)
returns public.community_sessions
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_session public.community_sessions;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if not exists (
    select 1
    from public.community_places cp
    where cp.id = p_place_id
  ) then
    raise exception 'Community place not found.';
  end if;

  if not exists (
    select 1
    from public.community_memberships cm
    where cm.place_id = p_place_id
      and cm.user_id = auth.uid()
      and cm.status = 'active'
  ) then
    raise exception 'Join this community before creating a session.';
  end if;

  if p_ends_at <= p_starts_at then
    raise exception 'Session end time must be after start time.';
  end if;

  if p_capacity is not null
     and (p_capacity < 1 or p_capacity > 100000) then
    raise exception 'Capacity must be between 1 and 100000.';
  end if;

  insert into public.community_sessions (
    created_by,
    place_id,
    title,
    description,
    location_name,
    location_details,
    starts_at,
    ends_at,
    capacity,
    status
  )
  values (
    auth.uid(),
    p_place_id,
    btrim(p_title),
    nullif(btrim(p_description), ''),
    btrim(p_location_name),
    nullif(btrim(p_location_details), ''),
    p_starts_at,
    p_ends_at,
    p_capacity,
    'planned'
  )
  returning * into v_session;

  return v_session;
end;
$function$;

revoke all
on function public.create_community_session(
  uuid,
  text,
  text,
  text,
  text,
  timestamptz,
  timestamptz,
  integer
)
from public;

grant execute
on function public.create_community_session(
  uuid,
  text,
  text,
  text,
  text,
  timestamptz,
  timestamptz,
  integer
)
to authenticated;
