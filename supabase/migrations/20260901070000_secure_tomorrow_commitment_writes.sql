-- Secure tomorrow daily commitment writes.

create or replace function public.create_tomorrow_daily_commitment(
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
    current_date + 1,
    btrim(p_commitment_text),
    'pending'
  )
  returning * into v_commitment;

  return v_commitment;
end;
$function$;


create or replace function public.update_tomorrow_daily_commitment(
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

  update public.daily_commitments
  set
    commitment_text = btrim(p_commitment_text)
  where user_id = auth.uid()
    and commitment_date = current_date + 1
    and status = 'pending'
  returning * into v_commitment;

  if not found then
    raise exception 'No pending commitment found for tomorrow.';
  end if;

  return v_commitment;
end;
$function$;


revoke all
on function public.create_tomorrow_daily_commitment(text)
from public;

revoke all
on function public.update_tomorrow_daily_commitment(text)
from public;


grant execute
on function public.create_tomorrow_daily_commitment(text)
to authenticated;

grant execute
on function public.update_tomorrow_daily_commitment(text)
to authenticated;