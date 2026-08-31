-- Harden community routine creation.
-- Routine creation must go through a controlled RPC.
-- Only active community members may create routines for that place.

drop policy if exists "Users can create their own community routines"
on public.community_routines;

create or replace function public.create_community_routine(
  p_place_id uuid,
  p_weekday smallint,
  p_start_time time,
  p_title text,
  p_duration_minutes smallint default 60
)
returns public.community_routines
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_routine public.community_routines;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if not exists (
    select 1
    from public.community_places
    where id = p_place_id
  ) then
    raise exception 'Community place not found.';
  end if;

  if not exists (
    select 1
    from public.community_memberships
    where place_id = p_place_id
      and user_id = auth.uid()
      and status = 'active'
  ) then
    raise exception 'Join this community before creating a routine.';
  end if;

  if p_weekday < 1 or p_weekday > 7 then
    raise exception 'Weekday must be between 1 and 7.';
  end if;

  if p_duration_minutes < 30 or p_duration_minutes > 120 then
    raise exception 'Duration must be between 30 and 120 minutes.';
  end if;

  if p_title is null or char_length(btrim(p_title)) = 0 then
    raise exception 'Routine title cannot be empty.';
  end if;

  insert into public.community_routines (
    place_id,
    created_by,
    weekday,
    start_time,
    duration_minutes,
    title,
    is_active
  )
  values (
    p_place_id,
    auth.uid(),
    p_weekday,
    p_start_time,
    p_duration_minutes,
    btrim(p_title),
    true
  )
  returning * into v_routine;

  return v_routine;
end;
$function$;

revoke all
on function public.create_community_routine(
  uuid,
  smallint,
  time,
  text,
  smallint
)
from public;

grant execute
on function public.create_community_routine(
  uuid,
  smallint,
  time,
  text,
  smallint
)
to authenticated;
