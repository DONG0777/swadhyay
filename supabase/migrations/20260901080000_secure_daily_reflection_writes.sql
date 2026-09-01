-- Harden daily reflection writes.

drop policy if exists "Users can insert own daily reflections"
on public.daily_reflections;

drop policy if exists "Users can update own daily reflections"
on public.daily_reflections;


create or replace function public.save_daily_reflection(
  p_commitment_id uuid,
  p_ego_reflection text default null,
  p_ideal_gap_reflection text default null,
  p_learning_reflection text default null,
  p_obstacle_reason text default null
)
returns public.daily_reflections
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_reflection public.daily_reflections;
  v_commitment public.daily_commitments;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  select *
  into v_commitment
  from public.daily_commitments
  where id = p_commitment_id
    and user_id = auth.uid()
    and commitment_date = current_date;

  if not found then
    raise exception 'Today''s commitment not found.';
  end if;

  if v_commitment.status = 'pending' then
    raise exception 'Today''s commitment must be completed or marked missed before reflection.';
  end if;

  if p_ego_reflection is not null
     and char_length(btrim(p_ego_reflection)) > 2000 then
    raise exception 'Ego reflection cannot be longer than 2000 characters.';
  end if;

  if p_ideal_gap_reflection is not null
     and char_length(btrim(p_ideal_gap_reflection)) > 2000 then
    raise exception 'Ideal gap reflection cannot be longer than 2000 characters.';
  end if;

  if p_learning_reflection is not null
     and char_length(btrim(p_learning_reflection)) > 2000 then
    raise exception 'Learning reflection cannot be longer than 2000 characters.';
  end if;

  if p_obstacle_reason is not null
     and char_length(btrim(p_obstacle_reason)) > 1000 then
    raise exception 'Obstacle reason cannot be longer than 1000 characters.';
  end if;

  if v_commitment.status = 'missed'
     and (
       p_obstacle_reason is null
       or char_length(btrim(p_obstacle_reason)) = 0
     ) then
    raise exception 'Obstacle reason is required for a missed commitment.';
  end if;

  insert into public.daily_reflections (
    user_id,
    commitment_id,
    reflection_date,
    ego_reflection,
    ideal_gap_reflection,
    learning_reflection,
    obstacle_reason
  )
  values (
    auth.uid(),
    v_commitment.id,
    current_date,
    nullif(btrim(p_ego_reflection), ''),
    nullif(btrim(p_ideal_gap_reflection), ''),
    nullif(btrim(p_learning_reflection), ''),
    case
      when v_commitment.status = 'missed'
        then nullif(btrim(p_obstacle_reason), '')
      else null
    end
  )
  on conflict (user_id, reflection_date)
  do update set
    commitment_id = excluded.commitment_id,
    ego_reflection = excluded.ego_reflection,
    ideal_gap_reflection = excluded.ideal_gap_reflection,
    learning_reflection = excluded.learning_reflection,
    obstacle_reason = excluded.obstacle_reason
  returning *
  into v_reflection;

  return v_reflection;
end;
$function$;


revoke all
on function public.save_daily_reflection(
  uuid,
  text,
  text,
  text,
  text
)
from public;


grant execute
on function public.save_daily_reflection(
  uuid,
  text,
  text,
  text,
  text
)
to authenticated;