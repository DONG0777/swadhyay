create table if not exists public.community_sessions (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references auth.users(id) on delete cascade,

  title text not null,
  description text,
  location_name text not null,
  location_details text,

  starts_at timestamptz not null,
  ends_at timestamptz not null,

  capacity integer,
  status text not null default 'planned',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint community_sessions_title_check
    check (char_length(btrim(title)) between 1 and 200),

  constraint community_sessions_description_check
    check (
      description is null
      or char_length(btrim(description)) <= 2000
    ),

  constraint community_sessions_location_name_check
    check (char_length(btrim(location_name)) between 1 and 300),

  constraint community_sessions_location_details_check
    check (
      location_details is null
      or char_length(btrim(location_details)) <= 1000
    ),

  constraint community_sessions_time_check
    check (ends_at > starts_at),

  constraint community_sessions_capacity_check
    check (
      capacity is null
      or (capacity >= 1 and capacity <= 100000)
    ),

  constraint community_sessions_status_check
    check (status in ('planned', 'cancelled', 'completed'))
);

create table if not exists public.session_participants (
  session_id uuid not null
    references public.community_sessions(id)
    on delete cascade,

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  joined_at timestamptz not null default now(),
  attendance_status text not null default 'pending',
  attended_at timestamptz,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint session_participants_pkey
    primary key (session_id, user_id),

  constraint session_participants_attendance_status_check
    check (
      attendance_status in ('pending', 'attended', 'absent')
    )
);

alter table public.community_sessions enable row level security;

alter table public.session_participants enable row level security;

create policy "Authenticated users can view community sessions"
on public.community_sessions
for select
to authenticated
using (true);

create policy "Users can create their own community sessions"
on public.community_sessions
for insert
to authenticated
with check (created_by = auth.uid());

create policy "Users can update their own community sessions"
on public.community_sessions
for update
to authenticated
using (created_by = auth.uid())
with check (created_by = auth.uid());

create policy "Users can delete their own community sessions"
on public.community_sessions
for delete
to authenticated
using (created_by = auth.uid());

create policy "Authenticated users can view session participants"
on public.session_participants
for select
to authenticated
using (true);

create policy "Users can join community sessions"
on public.session_participants
for insert
to authenticated
with check (user_id = auth.uid());

create policy "Users can update their own participation"
on public.session_participants
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "Users can leave community sessions"
on public.session_participants
for delete
to authenticated
using (user_id = auth.uid());

create or replace function public.set_community_session_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

create trigger community_sessions_set_updated_at
before update on public.community_sessions
for each row
execute function public.set_community_session_updated_at();

create or replace function public.set_session_participant_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

create trigger session_participants_set_updated_at
before update on public.session_participants
for each row
execute function public.set_session_participant_updated_at();
