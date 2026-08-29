alter table public.daily_commitments
  add constraint daily_commitments_id_user_unique
  unique (id, user_id);

create table if not exists public.daily_reflections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  commitment_id uuid not null,
  reflection_date date not null default current_date,

  ego_reflection text,
  ideal_gap_reflection text,
  learning_reflection text,
  obstacle_reason text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint daily_reflections_user_date_unique
    unique (user_id, reflection_date),

  constraint daily_reflections_ego_reflection_check
    check (
      ego_reflection is null
      or char_length(btrim(ego_reflection)) <= 2000
    ),

  constraint daily_reflections_ideal_gap_reflection_check
    check (
      ideal_gap_reflection is null
      or char_length(btrim(ideal_gap_reflection)) <= 2000
    ),

  constraint daily_reflections_learning_reflection_check
    check (
      learning_reflection is null
      or char_length(btrim(learning_reflection)) <= 2000
    ),

  constraint daily_reflections_obstacle_reason_check
    check (
      obstacle_reason is null
      or char_length(btrim(obstacle_reason)) <= 1000
    ),

  constraint daily_reflections_commitment_user_fkey
    foreign key (commitment_id, user_id)
    references public.daily_commitments (id, user_id)
    on delete restrict
);

alter table public.daily_reflections enable row level security;

create policy "Users can view own daily reflections"
on public.daily_reflections
for select
to authenticated
using (user_id = auth.uid());

create policy "Users can insert own daily reflections"
on public.daily_reflections
for insert
to authenticated
with check (user_id = auth.uid());

create policy "Users can update own daily reflections"
on public.daily_reflections
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create or replace function public.set_daily_reflection_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

create trigger daily_reflections_set_updated_at
before update on public.daily_reflections
for each row
execute function public.set_daily_reflection_updated_at();
