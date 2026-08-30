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
  v_member_exists boolean;
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
  into v_member_exists;

  if not v_member_exists then
    insert into public.community_memberships (
      place_id,
      user_id,
      status,
      joined_at,
      left_at
    )
    values (
      v_session.place_id,
      auth.uid(),
      'active',
      now(),
      null
    )
    on conflict (place_id, user_id)
    do update set
      status = 'active',
      left_at = null,
      updated_at = now();
  end if;

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
    attendance_status
  )
  values (
    p_session_id,
    auth.uid(),
    'pending'
  )
  returning * into v_participant;

  return v_participant;
end;
$function$;

revoke all
on function public.join_community_session(uuid)
from public;

grant execute
on function public.join_community_session(uuid)
to authenticated;
