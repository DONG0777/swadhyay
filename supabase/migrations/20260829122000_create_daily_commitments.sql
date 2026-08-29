create table if not exists public.daily_commitments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  commitment_date date not null default current_date,
  commitment_text text not null,
  status text not null default 'pending',
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint daily_commitments_user_date_unique
    unique (user_id, commitment_date),

  constraint daily_commitments_status_check
    check (status in ('pending', 'completed')),

  constraint daily_commitments_text_check
    check (char_length(btrim(commitment_text)) between 1 and 500)
);

alter table public.daily_commitments enable row level security;

create policy "Users can view own daily commitments"
on public.daily_commitments
for select
to authenticated
using (user_id = auth.uid());

create policy "Users can insert own daily commitments"
on public.daily_commitments
for insert
to authenticated
with check (user_id = auth.uid());

create policy "Users can update own daily commitments"
on public.daily_commitments
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create or replace function public.set_daily_commitment_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

create trigger daily_commitments_set_updated_at
before update on public.daily_commitments
for each row
execute function public.set_daily_commitment_updated_at();
