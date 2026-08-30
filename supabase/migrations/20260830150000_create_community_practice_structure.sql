create table if not exists public.community_places (
  id uuid primary key default gen_random_uuid(),

  created_by uuid not null
    references auth.users(id) on delete cascade,

  name text not null,
  description text,
  address text not null,

  timezone text not null default 'Asia/Kolkata',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint community_places_name_check
    check (char_length(btrim(name)) between 1 and 200),

  constraint community_places_description_check
    check (
      description is null
      or char_length(btrim(description)) <= 2000
    ),

  constraint community_places_address_check
    check (char_length(btrim(address)) between 1 and 500),

  constraint community_places_timezone_check
    check (char_length(btrim(timezone)) between 1 and 100)
);

create table if not exists public.community_routines (
  id uuid primary key default gen_random_uuid(),

  place_id uuid not null
    references public.community_places(id) on delete cascade,

  created_by uuid not null
    references auth.users(id) on delete cascade,

  weekday smallint not null,
  start_time time not null,
  duration_minutes smallint not null default 60,

  title text not null,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint community_routines_weekday_check
    check (weekday between 1 and 7),

  constraint community_routines_duration_check
    check (duration_minutes between 30 and 120),

  constraint community_routines_title_check
    check (char_length(btrim(title)) between 1 and 200)
);

create table if not exists public.community_session_agenda_items (
  id uuid primary key default gen_random_uuid(),

  session_id uuid not null
    references public.community_sessions(id) on delete cascade,

  sequence_number smallint not null,
  activity_type text not null,
  title text not null,
  description text,
  duration_minutes smallint not null,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint community_session_agenda_sequence_check
    check (sequence_number >= 1),

  constraint community_session_agenda_duration_check
    check (duration_minutes between 1 and 60),

  constraint community_session_agenda_title_check
    check (char_length(btrim(title)) between 1 and 200),

  constraint community_session_agenda_description_check
    check (
      description is null
      or char_length(btrim(description)) <= 2000
    ),

  constraint community_session_agenda_activity_type_check
    check (
      activity_type in (
        'gathering',
        'prayer',
        'surya_namaskar',
        'mindfulness',
        'self_study',
        'social_dialogue',
        'seva',
        'sankalpa',
        'closing'
      )
    ),

  constraint community_session_agenda_unique_sequence
    unique (session_id, sequence_number)
);

alter table public.community_sessions
  add column if not exists place_id uuid
    references public.community_places(id)
    on delete set null;

alter table public.community_sessions
  add column if not exists routine_id uuid
    references public.community_routines(id)
    on delete set null;

alter table public.community_places enable row level security;
alter table public.community_routines enable row level security;
alter table public.community_session_agenda_items enable row level security;

create policy "Authenticated users can view community places"
on public.community_places
for select
to authenticated
using (true);

create policy "Users can create their own community places"
on public.community_places
for insert
to authenticated
with check (created_by = auth.uid());

create policy "Users can update their own community places"
on public.community_places
for update
to authenticated
using (created_by = auth.uid())
with check (created_by = auth.uid());

create policy "Users can delete their own community places"
on public.community_places
for delete
to authenticated
using (created_by = auth.uid());

create policy "Authenticated users can view community routines"
on public.community_routines
for select
to authenticated
using (true);

create policy "Users can create their own community routines"
on public.community_routines
for insert
to authenticated
with check (created_by = auth.uid());

create policy "Users can update their own community routines"
on public.community_routines
for update
to authenticated
using (created_by = auth.uid())
with check (created_by = auth.uid());

create policy "Users can delete their own community routines"
on public.community_routines
for delete
to authenticated
using (created_by = auth.uid());

create policy "Authenticated users can view session agenda"
on public.community_session_agenda_items
for select
to authenticated
using (true);

create policy "Session creators can create agenda items"
on public.community_session_agenda_items
for insert
to authenticated
with check (
  exists (
    select 1
    from public.community_sessions s
    where s.id = session_id
      and s.created_by = auth.uid()
  )
);

create policy "Session creators can update agenda items"
on public.community_session_agenda_items
for update
to authenticated
using (
  exists (
    select 1
    from public.community_sessions s
    where s.id = session_id
      and s.created_by = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.community_sessions s
    where s.id = session_id
      and s.created_by = auth.uid()
  )
);

create policy "Session creators can delete agenda items"
on public.community_session_agenda_items
for delete
to authenticated
using (
  exists (
    select 1
    from public.community_sessions s
    where s.id = session_id
      and s.created_by = auth.uid()
  )
);

create or replace function public.set_community_place_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists community_places_set_updated_at
on public.community_places;

create trigger community_places_set_updated_at
before update on public.community_places
for each row
execute function public.set_community_place_updated_at();

create or replace function public.set_community_routine_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists community_routines_set_updated_at
on public.community_routines;

create trigger community_routines_set_updated_at
before update on public.community_routines
for each row
execute function public.set_community_routine_updated_at();

create or replace function public.set_community_agenda_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists community_session_agenda_items_set_updated_at
on public.community_session_agenda_items;

create trigger community_session_agenda_items_set_updated_at
before update on public.community_session_agenda_items
for each row
execute function public.set_community_agenda_updated_at();
