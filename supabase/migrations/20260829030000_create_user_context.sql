create table if not exists public.user_context (
  user_id uuid primary key references auth.users(id) on delete cascade,
  current_situation text,
  biggest_need text,
  available_time_minutes integer,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint user_context_available_time_minutes_check
    check (
      available_time_minutes is null
      or (available_time_minutes >= 0 and available_time_minutes <= 1440)
    )
);

alter table public.user_context enable row level security;

create policy "Users can view own context"
on public.user_context
for select
to authenticated
using (user_id = auth.uid());

create policy "Users can insert own context"
on public.user_context
for insert
to authenticated
with check (user_id = auth.uid());

create policy "Users can update own context"
on public.user_context
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create or replace function public.set_user_context_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

create trigger user_context_set_updated_at
before update on public.user_context
for each row
execute function public.set_user_context_updated_at();
