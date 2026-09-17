-- Add a secure RPC for creating one community routine
-- with multiple selected weekdays.
--
-- The legacy create_community_routine(...) RPC remains intact
-- until the application layer is migrated.

create or replace function public.create_community_routine_multi_day(
  p_place_id uuid,
  p_weekdays smallint[],
  p_start_time time,
  p_title text,
  p_duration_minutes smallint default 60
)
returns public.community_routines
language plpgsql
security definer
set search_path to 'public'
as $function$
declare
  v_routine public.community_routines;
  v_weekdays smallint[];
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

  if p_weekdays is null or cardinality(p_weekdays) = 0 then
    raise exception 'Select at least one weekday.';
  end if;

  if exists (
    select 1
    from unnest(p_weekdays) as d(weekday)
    where d.weekday < 1
       or d.weekday > 7
  ) then
    raise exception 'Weekday must be between 1 and 7.';
  end if;

  v_weekdays := array(
    select distinct d.weekday
    from unnest(p_weekdays) as d(weekday)
    order by d.weekday
  );

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
    v_weekdays[1],
    p_start_time,
    p_duration_minutes,
    btrim(p_title),
    true
  )
  returning * into v_routine;

  insert into public.community_routine_days (
    routine_id,
    weekday
  )
  select
    v_routine.id,
    d.weekday
  from unnest(v_weekdays) as d(weekday);

  return v_routine;
end;
$function$;

revoke all on function public.create_community_routine_multi_day(
  uuid,
  smallint[],
  time,
  text,
  smallint
) from public;

grant execute on function public.create_community_routine_multi_day(
  uuid,
  smallint[],
  time,
  text,
  smallint
) to authenticated;
