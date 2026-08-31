-- Harden community place creation.
-- Place creation must go through a controlled RPC.

drop policy if exists "Users can create their own community places"
on public.community_places;

create or replace function public.create_community_place(
  p_name text,
  p_description text,
  p_address text,
  p_timezone text default 'Asia/Kolkata'
)
returns public.community_places
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_place public.community_places;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if p_name is null or char_length(btrim(p_name)) = 0 then
    raise exception 'Place name cannot be empty.';
  end if;

  if p_address is null or char_length(btrim(p_address)) = 0 then
    raise exception 'Address cannot be empty.';
  end if;

  if p_timezone is null or char_length(btrim(p_timezone)) = 0 then
    raise exception 'Timezone cannot be empty.';
  end if;

  insert into public.community_places (
    created_by,
    name,
    description,
    address,
    timezone
  )
  values (
    auth.uid(),
    btrim(p_name),
    nullif(btrim(p_description), ''),
    btrim(p_address),
    btrim(p_timezone)
  )
  returning * into v_place;

  return v_place;
end;
$function$;

revoke all
on function public.create_community_place(
  text,
  text,
  text,
  text
)
from public;

grant execute
on function public.create_community_place(
  text,
  text,
  text,
  text
)
to authenticated;
