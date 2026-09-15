begin;

create table if not exists public.community_session_agenda_item_translations (
  id uuid primary key default gen_random_uuid(),

  agenda_item_id uuid not null
    references public.community_session_agenda_items(id)
    on delete cascade,

  language_code text not null,

  title text not null,
  description text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint community_agenda_translation_language_check
    check (language_code in ('bn', 'hi', 'en')),

  constraint community_agenda_translation_title_check
    check (char_length(btrim(title)) between 1 and 200),

  constraint community_agenda_translation_description_check
    check (
      description is null
      or char_length(btrim(description)) <= 2000
    ),

  constraint community_agenda_translation_unique
    unique (agenda_item_id, language_code)
);

alter table public.community_session_agenda_item_translations
  enable row level security;

create policy "Authenticated users can view agenda translations"
on public.community_session_agenda_item_translations
for select
to authenticated
using (true);

create policy "Session creators can create agenda translations"
on public.community_session_agenda_item_translations
for insert
to authenticated
with check (
  exists (
    select 1
    from public.community_session_agenda_items a
    join public.community_sessions s
      on s.id = a.session_id
    where a.id = agenda_item_id
      and s.created_by = auth.uid()
  )
);

create policy "Session creators can update agenda translations"
on public.community_session_agenda_item_translations
for update
to authenticated
using (
  exists (
    select 1
    from public.community_session_agenda_items a
    join public.community_sessions s
      on s.id = a.session_id
    where a.id = agenda_item_id
      and s.created_by = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.community_session_agenda_items a
    join public.community_sessions s
      on s.id = a.session_id
    where a.id = agenda_item_id
      and s.created_by = auth.uid()
  )
);

create policy "Session creators can delete agenda translations"
on public.community_session_agenda_item_translations
for delete
to authenticated
using (
  exists (
    select 1
    from public.community_session_agenda_items a
    join public.community_sessions s
      on s.id = a.session_id
    where a.id = agenda_item_id
      and s.created_by = auth.uid()
  )
);

create or replace function public.set_community_agenda_translation_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists community_agenda_translation_set_updated_at
on public.community_session_agenda_item_translations;

create trigger community_agenda_translation_set_updated_at
before update
on public.community_session_agenda_item_translations
for each row
execute function public.set_community_agenda_translation_updated_at();

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
where a.activity_type in (
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
where a.activity_type in (
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

commit;