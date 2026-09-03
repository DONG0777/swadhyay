create table if not exists public.learning_progress (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  learning_content_id uuid not null
    references public.learning_contents(id)
    on delete cascade,

  status text not null default 'completed',

  completed_at timestamptz not null default now(),

  created_at timestamptz not null default now(),

  updated_at timestamptz not null default now(),

  constraint learning_progress_status_check
    check (status in ('completed')),

  constraint learning_progress_unique_user_content
    unique (user_id, learning_content_id)
);

alter table public.learning_progress
  enable row level security;

create policy "Users can view their own learning progress"
on public.learning_progress
for select
to authenticated
using (user_id = auth.uid());

create or replace function public.complete_learning_content(
  p_learning_content_id uuid
)
returns public.learning_progress
language plpgsql
security definer
set search_path = public
as $$
declare
  result public.learning_progress;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if not exists (
    select 1
    from public.learning_contents
    where id = p_learning_content_id
      and status = 'published'
  ) then
    raise exception 'Learning content is not available.';
  end if;

  insert into public.learning_progress (
    user_id,
    learning_content_id,
    status,
    completed_at
  )
  values (
    auth.uid(),
    p_learning_content_id,
    'completed',
    now()
  )
  on conflict (user_id, learning_content_id)
  do update set
    status = 'completed',
    completed_at = now(),
    updated_at = now()
  returning * into result;

  return result;
end;
$$;

revoke all on function public.complete_learning_content(uuid)
from public;

grant execute on function public.complete_learning_content(uuid)
to authenticated;
