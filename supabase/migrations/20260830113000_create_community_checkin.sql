create table if not exists public.community_session_checkin_tokens (
  session_id uuid primary key
    references public.community_sessions(id)
    on delete cascade,

  token uuid not null unique default gen_random_uuid(),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.community_session_checkin_tokens
  enable row level security;

drop policy if exists "Session creators can view their checkin token"
on public.community_session_checkin_tokens;

create policy "Session creators can view their checkin token"
on public.community_session_checkin_tokens
for select
to authenticated
using (
  exists (
    select 1
    from public.community_sessions s
    where s.id = session_id
      and s.created_by = auth.uid()
  )
);

drop policy if exists "Users can update their own participation"
on public.session_participants;

create or replace function public.create_community_session_checkin_token(
  p_session_id uuid
)
returns uuid
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_token uuid;
begin
  if not exists (
    select 1
    from public.community_sessions
    where id = p_session_id
      and created_by = auth.uid()
      and status = 'planned'
  ) then
    raise exception 'You are not allowed to create a check-in token for this session.';
  end if;

  insert into public.community_session_checkin_tokens (
    session_id
  )
  values (
    p_session_id
  )
  on conflict (session_id)
  do update set
    updated_at = now()
  returning token into v_token;

  return v_token;
end;
$function$;

create or replace function public.check_in_to_community_session(
  p_token uuid
)
returns public.session_participants
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_session public.community_sessions;
  v_participant public.session_participants;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  select s.*
  into v_session
  from public.community_sessions s
  join public.community_session_checkin_tokens t
    on t.session_id = s.id
  where t.token = p_token;

  if not found then
    raise exception 'Invalid check-in code.';
  end if;

  if v_session.status <> 'planned' then
    raise exception 'This session is not available for check-in.';
  end if;

  if now() < (v_session.starts_at - interval '15 minutes')
     or now() > (v_session.ends_at + interval '15 minutes') then
    raise exception 'Check-in window is closed.';
  end if;

  if not exists (
    select 1
    from public.session_participants
    where session_id = v_session.id
      and user_id = auth.uid()
  ) then
    raise exception 'Join this session before checking in.';
  end if;

  update public.session_participants
  set
    attendance_status = 'attended',
    attended_at = coalesce(attended_at, now()),
    updated_at = now()
  where session_id = v_session.id
    and user_id = auth.uid()
  returning * into v_participant;

  if not found then
    raise exception 'Participation record not found.';
  end if;

  return v_participant;
end;
$function$;

revoke all
on function public.create_community_session_checkin_token(uuid)
from public;

grant execute
on function public.create_community_session_checkin_token(uuid)
to authenticated;

revoke all
on function public.check_in_to_community_session(uuid)
from public;

grant execute
on function public.check_in_to_community_session(uuid)
to authenticated;

create or replace function public.set_community_checkin_token_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists community_checkin_tokens_set_updated_at
on public.community_session_checkin_tokens;

create trigger community_checkin_tokens_set_updated_at
before update on public.community_session_checkin_tokens
for each row
execute function public.set_community_checkin_token_updated_at();
