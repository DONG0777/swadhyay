-- Enforce one active primary community per user
-- and distinguish member vs guest session participation.

create unique index if not exists community_memberships_one_active_per_user_idx
on public.community_memberships (user_id)
where status = 'active';

alter table public.session_participants
  add column if not exists participant_type text
  not null default 'member';

alter table public.session_participants
  drop constraint if exists session_participants_participant_type_check;

alter table public.session_participants
  add constraint session_participants_participant_type_check
  check (participant_type in ('member', 'guest'));

create or replace function public.auto_add_place_creator_as_member()
returns trigger
language plpgsql
security definer
set search_path = public
as $function$
begin
  if exists (
    select 1
    from public.community_memberships m
    where m.user_id = new.created_by
      and m.status = 'active'
  ) then
    raise exception 'User already has a primary community.';
  end if;

  insert into public.community_memberships (
    place_id,
    user_id,
    status,
    joined_at,
    left_at
  )
  values (
    new.id,
    new.created_by,
    'active',
    now(),
    null
  );

  return new;
end;
$function$;

create or replace function public.join_community_place(
  p_place_id uuid
)
returns public.community_memberships
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_membership public.community_memberships;
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

  select *
  into v_membership
  from public.community_memberships
  where place_id = p_place_id
    and user_id = auth.uid();

  if found and v_membership.status = 'active' then
    return v_membership;
  end if;

  if exists (
    select 1
    from public.community_memberships m
    where m.user_id = auth.uid()
      and m.status = 'active'
      and m.place_id <> p_place_id
  ) then
    raise exception 'You already have a primary community.';
  end if;

  insert into public.community_memberships (
    place_id,
    user_id,
    status,
    joined_at,
    left_at
  )
  values (
    p_place_id,
    auth.uid(),
    'active',
    now(),
    null
  )
  on conflict (place_id, user_id)
  do update set
    status = 'active',
    left_at = null,
    joined_at = case
      when public.community_memberships.status = 'left'
        then now()
      else public.community_memberships.joined_at
    end,
    updated_at = now()
  returning * into v_membership;

  return v_membership;
end;
$function$;

create or replace function public.join_community_session(
  p_session_id uuid
)
returns public.session_participants
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_session public.community_sessions;
  v_participant public.session_participants;
  v_is_member boolean;
  v_participant_type text;
  v_count integer;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  select *
  into v_session
  from public.community_sessions
  where id = p_session_id
  for update;

  if not found then
    raise exception 'Community session not found.';
  end if;

  if v_session.status <> 'planned' then
    raise exception 'This session is not open for joining.';
  end if;

  if v_session.place_id is null then
    raise exception 'This session is not linked to a community place.';
  end if;

  select exists (
    select 1
    from public.community_memberships m
    where m.place_id = v_session.place_id
      and m.user_id = auth.uid()
      and m.status = 'active'
  )
  into v_is_member;

  v_participant_type :=
    case
      when v_is_member then 'member'
      else 'guest'
    end;

  if exists (
    select 1
    from public.session_participants p
    where p.session_id = p_session_id
      and p.user_id = auth.uid()
  ) then
    select *
    into v_participant
    from public.session_participants
    where session_id = p_session_id
      and user_id = auth.uid();

    return v_participant;
  end if;

  select count(*)::integer
  into v_count
  from public.session_participants
  where session_id = p_session_id;

  if v_session.capacity is not null
     and v_count >= v_session.capacity then
    raise exception 'This session is full.';
  end if;

  insert into public.session_participants (
    session_id,
    user_id,
    attendance_status,
    participant_type
  )
  values (
    p_session_id,
    auth.uid(),
    'pending',
    v_participant_type
  )
  returning * into v_participant;

  return v_participant;
end;
$function$;

revoke all
on function public.join_community_place(uuid)
from public;

grant execute
on function public.join_community_place(uuid)
to authenticated;

revoke all
on function public.join_community_session(uuid)
from public;

grant execute
on function public.join_community_session(uuid)
to authenticated;
