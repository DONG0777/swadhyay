begin;

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

    insert into public.community_session_agenda_item_translations (
      agenda_item_id,
      language_code,
      title,
      description
    )
    select
      a.id,
      'bn',
      a.title,
      a.description
    from public.community_session_agenda_items a
    where a.session_id = p_session_id
      and a.activity_type in (
        'gathering',
        'prayer',
        'surya_namaskar',
        'mindfulness',
        'self_study',
        'social_dialogue',
        'seva',
        'closing'
      )
    on conflict (agenda_item_id, language_code) do nothing;

    insert into public.community_session_agenda_item_translations (
      agenda_item_id,
      language_code,
      title,
      description
    )
    select
      a.id,
      'hi',
      case a.activity_type
        when 'gathering' then 'एकत्र होना'
        when 'prayer' then 'प्रार्थना / शांति का क्षण'
        when 'surya_namaskar' then 'सूर्य नमस्कार'
        when 'mindfulness' then 'सजगता'
        when 'self_study' then 'स्वाध्याय'
        when 'social_dialogue' then 'सामाजिक संवाद'
        when 'seva' then 'सेवा + संकल्प'
        when 'closing' then 'समापन'
      end,
      case a.activity_type
        when 'gathering' then 'सभी एकत्र होकर अभ्यास के लिए तैयार होंगे।'
        when 'prayer' then 'मन को स्थिर करके सामूहिक रूप से दिन का अभ्यास शुरू करना।'
        when 'surya_namaskar' then 'शरीर, श्वास और अनुशासन का सामूहिक अभ्यास।'
        when 'mindfulness' then 'कुछ समय मौन, श्वास और आत्म-निरीक्षण।'
        when 'self_study' then 'किसी मूल्य या विचार के विषय पर संक्षिप्त चर्चा।'
        when 'social_dialogue' then 'स्थानीय समाज और पारस्परिक जिम्मेदारी पर बातचीत।'
        when 'seva' then 'अगले दिन के छोटे सामाजिक या व्यक्तिगत कार्य का निर्धारण।'
        when 'closing' then 'संक्षिप्त समापन और अगले सत्र के लिए तैयारी।'
      end
    from public.community_session_agenda_items a
    where a.session_id = p_session_id
      and a.activity_type in (
        'gathering',
        'prayer',
        'surya_namaskar',
        'mindfulness',
        'self_study',
        'social_dialogue',
        'seva',
        'closing'
      )
    on conflict (agenda_item_id, language_code) do nothing;

    insert into public.community_session_agenda_item_translations (
      agenda_item_id,
      language_code,
      title,
      description
    )
    select
      a.id,
      'en',
      case a.activity_type
        when 'gathering' then 'Gathering'
        when 'prayer' then 'Prayer / Quiet Moment'
        when 'surya_namaskar' then 'Surya Namaskar'
        when 'mindfulness' then 'Mindfulness'
        when 'self_study' then 'Self-Study'
        when 'social_dialogue' then 'Social Dialogue'
        when 'seva' then 'Seva + Sankalpa'
        when 'closing' then 'Closing'
      end,
      case a.activity_type
        when 'gathering' then 'Everyone gathers and prepares for the practice.'
        when 'prayer' then 'Center the mind and begin the day’s practice together.'
        when 'surya_namaskar' then 'A collective practice of body, breath, and discipline.'
        when 'mindfulness' then 'A short period of silence, breathing, and self-observation.'
        when 'self_study' then 'A brief discussion on a value or topic for reflection.'
        when 'social_dialogue' then 'A conversation about the local community and shared responsibility.'
        when 'seva' then 'Choose a small social or personal action for the next day.'
        when 'closing' then 'A brief closing and preparation for the next session.'
      end
    from public.community_session_agenda_items a
    where a.session_id = p_session_id
      and a.activity_type in (
        'gathering',
        'prayer',
        'surya_namaskar',
        'mindfulness',
        'self_study',
        'social_dialogue',
        'seva',
        'closing'
      )
    on conflict (agenda_item_id, language_code) do nothing;

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

  insert into public.community_session_agenda_item_translations (
    agenda_item_id,
    language_code,
    title,
    description
  )
  select
    a.id,
    'bn',
    a.title,
    a.description
  from public.community_session_agenda_items a
  where a.session_id = p_session_id
    and a.activity_type in (
      'gathering',
      'prayer',
      'surya_namaskar',
      'mindfulness',
      'self_study',
      'social_dialogue',
      'seva',
      'closing'
    )
  on conflict (agenda_item_id, language_code) do nothing;

  insert into public.community_session_agenda_item_translations (
    agenda_item_id,
    language_code,
    title,
    description
  )
  select
    a.id,
    'hi',
    case a.activity_type
      when 'gathering' then 'एकत्र होना'
      when 'prayer' then 'प्रार्थना / शांति का क्षण'
      when 'surya_namaskar' then 'सूर्य नमस्कार'
      when 'mindfulness' then 'सजगता'
      when 'self_study' then 'स्वाध्याय'
      when 'social_dialogue' then 'सामाजिक संवाद'
      when 'seva' then 'सेवा + संकल्प'
      when 'closing' then 'समापन'
    end,
    case a.activity_type
      when 'gathering' then 'सभी एकत्र होकर अभ्यास के लिए तैयार होंगे।'
      when 'prayer' then 'मन को स्थिर करके सामूहिक रूप से दिन का अभ्यास शुरू करना।'
      when 'surya_namaskar' then 'शरीर, श्वास और अनुशासन का सामूहिक अभ्यास।'
      when 'mindfulness' then 'कुछ समय मौन, श्वास और आत्म-निरीक्षण।'
      when 'self_study' then 'किसी मूल्य या विचार के विषय पर संक्षिप्त चर्चा।'
      when 'social_dialogue' then 'स्थानीय समाज और पारस्परिक जिम्मेदारी पर बातचीत।'
      when 'seva' then 'अगले दिन के छोटे सामाजिक या व्यक्तिगत कार्य का निर्धारण।'
      when 'closing' then 'संक्षिप्त समापन और अगले सत्र के लिए तैयारी।'
    end
  from public.community_session_agenda_items a
  where a.session_id = p_session_id
    and a.activity_type in (
      'gathering',
      'prayer',
      'surya_namaskar',
      'mindfulness',
      'self_study',
      'social_dialogue',
      'seva',
      'closing'
    )
  on conflict (agenda_item_id, language_code) do nothing;

  insert into public.community_session_agenda_item_translations (
    agenda_item_id,
    language_code,
    title,
    description
  )
  select
    a.id,
    'en',
    case a.activity_type
      when 'gathering' then 'Gathering'
      when 'prayer' then 'Prayer / Quiet Moment'
      when 'surya_namaskar' then 'Surya Namaskar'
      when 'mindfulness' then 'Mindfulness'
      when 'self_study' then 'Self-Study'
      when 'social_dialogue' then 'Social Dialogue'
      when 'seva' then 'Seva + Sankalpa'
      when 'closing' then 'Closing'
    end,
    case a.activity_type
      when 'gathering' then 'Everyone gathers and prepares for the practice.'
      when 'prayer' then 'Center the mind and begin the day’s practice together.'
      when 'surya_namaskar' then 'A collective practice of body, breath, and discipline.'
      when 'mindfulness' then 'A short period of silence, breathing, and self-observation.'
      when 'self_study' then 'A brief discussion on a value or topic for reflection.'
      when 'social_dialogue' then 'A conversation about the local community and shared responsibility.'
      when 'seva' then 'Choose a small social or personal action for the next day.'
      when 'closing' then 'A brief closing and preparation for the next session.'
    end
  from public.community_session_agenda_items a
  where a.session_id = p_session_id
    and a.activity_type in (
      'gathering',
      'prayer',
      'surya_namaskar',
      'mindfulness',
      'self_study',
      'social_dialogue',
      'seva',
      'closing'
    )
  on conflict (agenda_item_id, language_code) do nothing;

  return query
    select *
    from public.community_session_agenda_items
    where session_id = p_session_id
    order by sequence_number asc;
end;
$function$;

revoke all
on function public.create_default_community_session_agenda(uuid)
from public;

grant execute on function public.create_default_community_session_agenda(uuid)
to authenticated;

commit;
