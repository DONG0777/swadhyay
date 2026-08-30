create table if not exists public.learning_contents (
  id uuid primary key default gen_random_uuid(),

  created_by uuid
    references auth.users(id)
    on delete set null,

  content_kind text not null,
  category text not null,

  source_title text,
  source_author text,
  source_reference text,
  source_url text,

  estimated_minutes smallint not null default 5,
  difficulty text not null default 'easy',

  status text not null default 'draft',

  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint learning_contents_kind_check
    check (
      content_kind in (
        'knowledge',
        'quote',
        'story',
        'song',
        'reflection',
        'civic_thought',
        'seva_idea',
        'quiz'
      )
    ),

  constraint learning_contents_category_check
    check (
      char_length(btrim(category)) between 1 and 100
    ),

  constraint learning_contents_source_title_check
    check (
      source_title is null
      or char_length(btrim(source_title)) <= 300
    ),

  constraint learning_contents_source_author_check
    check (
      source_author is null
      or char_length(btrim(source_author)) <= 300
    ),

  constraint learning_contents_source_reference_check
    check (
      source_reference is null
      or char_length(btrim(source_reference)) <= 1000
    ),

  constraint learning_contents_source_url_check
    check (
      source_url is null
      or char_length(btrim(source_url)) <= 2000
    ),

  constraint learning_contents_minutes_check
    check (estimated_minutes between 1 and 60),

  constraint learning_contents_difficulty_check
    check (
      difficulty in ('easy', 'medium', 'advanced')
    ),

  constraint learning_contents_status_check
    check (
      status in (
        'draft',
        'submitted',
        'published',
        'archived'
      )
    )
);

create table if not exists public.learning_content_translations (
  id uuid primary key default gen_random_uuid(),

  content_id uuid not null
    references public.learning_contents(id)
    on delete cascade,

  language_code text not null,

  title text not null,
  summary text,
  body text,

  reflection_question text,
  action_prompt text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint learning_content_translations_language_check
    check (
      language_code in ('bn', 'hi', 'en')
    ),

  constraint learning_content_translations_title_check
    check (
      char_length(btrim(title)) between 1 and 300
    ),

  constraint learning_content_translations_summary_check
    check (
      summary is null
      or char_length(btrim(summary)) <= 1000
    ),

  constraint learning_content_translations_body_check
    check (
      body is null
      or char_length(btrim(body)) <= 10000
    ),

  constraint learning_content_translations_reflection_check
    check (
      reflection_question is null
      or char_length(btrim(reflection_question)) <= 1000
    ),

  constraint learning_content_translations_action_check
    check (
      action_prompt is null
      or char_length(btrim(action_prompt)) <= 1000
    ),

  constraint learning_content_translations_unique
    unique (content_id, language_code)
);

create table if not exists public.learning_quiz_questions (
  id uuid primary key default gen_random_uuid(),

  content_id uuid not null
    references public.learning_contents(id)
    on delete cascade,

  question_number smallint not null default 1,

  created_at timestamptz not null default now(),

  constraint learning_quiz_questions_number_check
    check (question_number >= 1),

  constraint learning_quiz_questions_unique
    unique (content_id, question_number)
);

create table if not exists public.learning_quiz_question_translations (
  id uuid primary key default gen_random_uuid(),

  question_id uuid not null
    references public.learning_quiz_questions(id)
    on delete cascade,

  language_code text not null,
  question_text text not null,
  explanation text,

  created_at timestamptz not null default now(),

  constraint learning_quiz_question_translations_language_check
    check (
      language_code in ('bn', 'hi', 'en')
    ),

  constraint learning_quiz_question_translations_question_check
    check (
      char_length(btrim(question_text)) between 1 and 2000
    ),

  constraint learning_quiz_question_translations_explanation_check
    check (
      explanation is null
      or char_length(btrim(explanation)) <= 3000
    ),

  constraint learning_quiz_question_translations_unique
    unique (question_id, language_code)
);

create table if not exists public.learning_quiz_options (
  id uuid primary key default gen_random_uuid(),

  question_id uuid not null
    references public.learning_quiz_questions(id)
    on delete cascade,

  option_number smallint not null,

  created_at timestamptz not null default now(),

  constraint learning_quiz_options_number_check
    check (option_number >= 1),

  constraint learning_quiz_options_unique
    unique (question_id, option_number)
);

create table if not exists public.learning_quiz_option_translations (
  id uuid primary key default gen_random_uuid(),

  option_id uuid not null
    references public.learning_quiz_options(id)
    on delete cascade,

  language_code text not null,
  option_text text not null,
  is_correct boolean not null default false,

  created_at timestamptz not null default now(),

  constraint learning_quiz_option_translations_language_check
    check (
      language_code in ('bn', 'hi', 'en')
    ),

  constraint learning_quiz_option_translations_text_check
    check (
      char_length(btrim(option_text)) between 1 and 1000
    ),

  constraint learning_quiz_option_translations_unique
    unique (option_id, language_code)
);

alter table public.learning_contents
  enable row level security;

alter table public.learning_content_translations
  enable row level security;

alter table public.learning_quiz_questions
  enable row level security;

alter table public.learning_quiz_question_translations
  enable row level security;

alter table public.learning_quiz_options
  enable row level security;

alter table public.learning_quiz_option_translations
  enable row level security;

create policy "Authenticated users can view published learning contents"
on public.learning_contents
for select
to authenticated
using (status = 'published');

create policy "Users can submit their own learning content"
on public.learning_contents
for insert
to authenticated
with check (
  created_by = auth.uid()
  and status in ('draft', 'submitted')
);

create policy "Users can edit their own unpublished learning content"
on public.learning_contents
for update
to authenticated
using (
  created_by = auth.uid()
  and status in ('draft', 'submitted')
)
with check (
  created_by = auth.uid()
  and status in ('draft', 'submitted')
);

create policy "Authenticated users can view translations of published content"
on public.learning_content_translations
for select
to authenticated
using (
  exists (
    select 1
    from public.learning_contents c
    where c.id = content_id
      and c.status = 'published'
  )
);

create policy "Users can create translations for their own unpublished content"
on public.learning_content_translations
for insert
to authenticated
with check (
  exists (
    select 1
    from public.learning_contents c
    where c.id = content_id
      and c.created_by = auth.uid()
      and c.status in ('draft', 'submitted')
  )
);

create policy "Authenticated users can view questions of published quizzes"
on public.learning_quiz_questions
for select
to authenticated
using (
  exists (
    select 1
    from public.learning_contents c
    where c.id = content_id
      and c.status = 'published'
      and c.content_kind = 'quiz'
  )
);

create policy "Authenticated users can view published quiz question translations"
on public.learning_quiz_question_translations
for select
to authenticated
using (
  exists (
    select 1
    from public.learning_quiz_questions q
    join public.learning_contents c
      on c.id = q.content_id
    where q.id = question_id
      and c.status = 'published'
      and c.content_kind = 'quiz'
  )
);

create policy "Authenticated users can view options of published quizzes"
on public.learning_quiz_options
for select
to authenticated
using (
  exists (
    select 1
    from public.learning_quiz_questions q
    join public.learning_contents c
      on c.id = q.content_id
    where q.id = question_id
      and c.status = 'published'
      and c.content_kind = 'quiz'
  )
);

create policy "Authenticated users can view published quiz option translations"
on public.learning_quiz_option_translations
for select
to authenticated
using (
  exists (
    select 1
    from public.learning_quiz_options o
    join public.learning_quiz_questions q
      on q.id = o.question_id
    join public.learning_contents c
      on c.id = q.content_id
    where o.id = option_id
      and c.status = 'published'
      and c.content_kind = 'quiz'
  )
);

create or replace function public.set_learning_content_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists learning_contents_set_updated_at
on public.learning_contents;

create trigger learning_contents_set_updated_at
before update on public.learning_contents
for each row
execute function public.set_learning_content_updated_at();

create or replace function public.set_learning_content_translation_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists learning_content_translations_set_updated_at
on public.learning_content_translations;

create trigger learning_content_translations_set_updated_at
before update on public.learning_content_translations
for each row
execute function public.set_learning_content_translation_updated_at();
