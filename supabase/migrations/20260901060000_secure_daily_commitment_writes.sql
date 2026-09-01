-- Harden daily commitment writes.

drop policy if exists "Users can insert own daily commitments"
on public.daily_commitments;

drop policy if exists "Users can update own daily commitments"
on public.daily_commitments;

create or replace function public.create_daily_commitment(
  p_commitment_text text
)
returns public.daily_commitments
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_commitment public.daily_commitments;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if p_commitment_text is null
     or char_length(btrim(p_commitment_text)) = 0 then
    raise exception 'Commitment cannot be empty.';
  end if;

  if char_length(btrim(p_commitment_text)) > 500 then
    raise exception 'Commitment cannot be longer than 500 characters.';
  end if;

  insert into public.daily_commitments (
    user_id,
    commitment_date,
    commitment_text,
    status
  )
  values (
    auth.uid(),
    current_date,
    btrim(p_commitment_text),
    'pending'
  )
  returning * into v_commitment;

  return v_commitment;
end;
$function$;

create or replace function public.complete_daily_commitment()
returns public.daily_commitments
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_commitment public.daily_commitments;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  update public.daily_commitments
  set
    status = 'completed',
    completed_at = now()
  where user_id = auth.uid()
    and commitment_date = current_date
    and status = 'pending'
  returning * into v_commitment;

  if not found then
    raise exception 'No pending commitment found for today.';
  end if;

  return v_commitment;
end;
$function$;

create or replace function public.mark_daily_commitment_missed()
returns public.daily_commitments
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_commitment public.daily_commitments;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  update public.daily_commitments
  set
    status = 'missed',
    completed_at = null
  where user_id = auth.uid()
    and commitment_date = current_date
    and status = 'pending'
  returning * into v_commitment;

  if not found then
    raise exception 'No pending commitment found for today.';
  end if;

  return v_commitment;
end;
$function$;

revoke all
on function public.create_daily_commitment(text)
from public;

revoke all
on function public.complete_daily_commitment()
from public;

revoke all
on function public.mark_daily_commitment_missed()
from public;

grant execute
on function public.create_daily_commitment(text)
to authenticated;

grant execute
on function public.complete_daily_commitment()
to authenticated;

grant execute
on function public.mark_daily_commitment_missed()
to authenticated;
