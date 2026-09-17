-- Add multi-day scheduling support for community routines.
-- Existing routines remain intact and their current weekday is migrated
-- into the new child table. The legacy weekday column is intentionally
-- retained for compatibility until the application layer is migrated.

create table if not exists public.community_routine_days (
  routine_id uuid not null
    references public.community_routines(id)
    on delete cascade,

  weekday smallint not null,

  created_at timestamptz not null default now(),

  constraint community_routine_days_pkey
    primary key (routine_id, weekday),

  constraint community_routine_days_weekday_check
    check (weekday between 1 and 7)
);

alter table public.community_routine_days enable row level security;

drop policy if exists "Authenticated users can view community routine days"
on public.community_routine_days;

create policy "Authenticated users can view community routine days"
on public.community_routine_days
for select
to authenticated
using (true);

drop policy if exists "Users can create their own community routine days"
on public.community_routine_days;

create policy "Users can create their own community routine days"
on public.community_routine_days
for insert
to authenticated
with check (
  exists (
    select 1
    from public.community_routines r
    where r.id = routine_id
      and r.created_by = auth.uid()
  )
);

drop policy if exists "Users can update their own community routine days"
on public.community_routine_days;

create policy "Users can update their own community routine days"
on public.community_routine_days
for update
to authenticated
using (
  exists (
    select 1
    from public.community_routines r
    where r.id = routine_id
      and r.created_by = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.community_routines r
    where r.id = routine_id
      and r.created_by = auth.uid()
  )
);

drop policy if exists "Users can delete their own community routine days"
on public.community_routine_days;

create policy "Users can delete their own community routine days"
on public.community_routine_days
for delete
to authenticated
using (
  exists (
    select 1
    from public.community_routines r
    where r.id = routine_id
      and r.created_by = auth.uid()
  )
);

insert into public.community_routine_days (
  routine_id,
  weekday
)
select
  r.id,
  r.weekday
from public.community_routines r
where r.weekday between 1 and 7
on conflict (routine_id, weekday) do nothing;

create index if not exists community_routine_days_weekday_idx
on public.community_routine_days (weekday);

create index if not exists community_routine_days_routine_id_idx
on public.community_routine_days (routine_id);
