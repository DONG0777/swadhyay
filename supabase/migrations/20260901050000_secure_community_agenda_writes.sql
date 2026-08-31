-- Harden community session agenda writes.
-- Agenda writes must go through controlled RPC functions.

drop policy if exists "Session creators can create agenda items"
on public.community_session_agenda_items;

drop policy if exists "Session creators can update agenda items"
on public.community_session_agenda_items;

drop policy if exists "Session creators can delete agenda items"
on public.community_session_agenda_items;

create or replace function public.add_community_session_agenda_item(
  p_session_id uuid,
  p_sequence_number smallint,
  p_activity_type text,
  p_title text,
  p_description text,
  p_duration_minutes smallint
)
returns public.community_session_agenda_items
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_item public.community_session_agenda_items;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if not exists (
    select 1
    from public.community_sessions s
    where s.id = p_session_id
      and s.created_by = auth.uid()
  ) then
    raise exception 'You are not allowed to modify this session agenda.';
  end if;

  if p_sequence_number < 1 then
    raise exception 'Sequence number must be at least 1.';
  end if;

  if p_duration_minutes < 1 or p_duration_minutes > 60 then
    raise exception 'Agenda duration must be between 1 and 60 minutes.';
  end if;

  if p_title is null or char_length(btrim(p_title)) = 0 then
    raise exception 'Agenda title cannot be empty.';
  end if;

  insert into public.community_session_agenda_items (
    session_id,
    sequence_number,
    activity_type,
    title,
    description,
    duration_minutes
  )
  values (
    p_session_id,
    p_sequence_number,
    p_activity_type,
    btrim(p_title),
    nullif(btrim(p_description), ''),
    p_duration_minutes
  )
  returning * into v_item;

  return v_item;
end;
$function$;

create or replace function public.update_community_session_agenda_item(
  p_item_id uuid,
  p_title text,
  p_description text,
  p_activity_type text,
  p_duration_minutes smallint
)
returns public.community_session_agenda_items
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_item public.community_session_agenda_items;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if p_title is null or char_length(btrim(p_title)) = 0 then
    raise exception 'Agenda title cannot be empty.';
  end if;

  if p_duration_minutes < 1 or p_duration_minutes > 60 then
    raise exception 'Agenda duration must be between 1 and 60 minutes.';
  end if;

  update public.community_session_agenda_items a
  set
    title = btrim(p_title),
    description = nullif(btrim(p_description), ''),
    activity_type = p_activity_type,
    duration_minutes = p_duration_minutes,
    updated_at = now()
  where a.id = p_item_id
    and exists (
      select 1
      from public.community_sessions s
      where s.id = a.session_id
        and s.created_by = auth.uid()
    )
  returning a.* into v_item;

  if not found then
    raise exception 'Agenda item not found or access denied.';
  end if;

  return v_item;
end;
$function$;

create or replace function public.delete_community_session_agenda_item(
  p_item_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $function$
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  delete from public.community_session_agenda_items a
  where a.id = p_item_id
    and exists (
      select 1
      from public.community_sessions s
      where s.id = a.session_id
        and s.created_by = auth.uid()
    );
end;
$function$;

create or replace function public.create_default_community_session_agenda(
  p_session_id uuid
)
returns setof public.community_session_agenda_items
language plpgsql
security definer
set search_path = public
as $function$
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if not exists (
    select 1
    from public.community_sessions s
    where s.id = p_session_id
      and s.created_by = auth.uid()
  ) then
    raise exception 'You are not allowed to modify this session agenda.';
  end if;

  if exists (
    select 1
    from public.community_session_agenda_items
    where session_id = p_session_id
  ) then
    return query
      select *
      from public.community_session_agenda_items
      where session_id = p_session_id
      order by sequence_number asc;

    return;
  end if;

  insert into public.community_session_agenda_items (
    session_id,
    sequence_number,
    activity_type,
    title,
    description,
    duration_minutes
  )
  values
    (p_session_id, 1, 'gathering', 'সমবেত হওয়া',
      'সবাই একত্রিত হয়ে অনুশীলনের জন্য প্রস্তুত হবে।', 5),
    (p_session_id, 2, 'prayer', 'প্রার্থনা / শান্তি মুহূর্ত',
      'মনকে স্থির করে সম্মিলিতভাবে দিনের অনুশীলন শুরু করা।', 5),
    (p_session_id, 3, 'surya_namaskar', 'সূর্য নমস্কার',
      'শরীর, শ্বাস ও শৃঙ্খলার সম্মিলিত অনুশীলন।', 15),
    (p_session_id, 4, 'mindfulness', 'মনন',
      'কিছু সময় নীরবতা, শ্বাস ও আত্ম-পর্যবেক্ষণ।', 10),
    (p_session_id, 5, 'self_study', 'স্বাধ্যায়',
      'একটি মূল্যবোধ বা চিন্তার বিষয় নিয়ে সংক্ষিপ্ত আলোচনা।', 10),
    (p_session_id, 6, 'social_dialogue', 'সামাজিক আলোচনা',
      'স্থানীয় সমাজ ও পারস্পরিক দায়িত্ব নিয়ে কথা বলা।', 5),
    (p_session_id, 7, 'seva', 'Seva + সংকল্প',
      'পরবর্তী দিনের ছোট সামাজিক বা ব্যক্তিগত কাজ নির্ধারণ।', 5),
    (p_session_id, 8, 'closing', 'সমাপ্তি',
      'সংক্ষিপ্ত সমাপ্তি ও পরবর্তী session-এর জন্য প্রস্তুতি।', 5);

  return query
    select *
    from public.community_session_agenda_items
    where session_id = p_session_id
    order by sequence_number asc;
end;
$function$;

revoke all
on function public.add_community_session_agenda_item(
  uuid, smallint, text, text, text, smallint
)
from public;

grant execute on function public.add_community_session_agenda_item(
  uuid, smallint, text, text, text, smallint
) to authenticated;

revoke all
on function public.update_community_session_agenda_item(
  uuid, text, text, text, smallint
)
from public;

grant execute on function public.update_community_session_agenda_item(
  uuid, text, text, text, smallint
) to authenticated;

revoke all
on function public.delete_community_session_agenda_item(uuid)
from public;

grant execute on function public.delete_community_session_agenda_item(uuid)
to authenticated;

revoke all
on function public.create_default_community_session_agenda(uuid)
from public;

grant execute on function public.create_default_community_session_agenda(uuid)
to authenticated;
