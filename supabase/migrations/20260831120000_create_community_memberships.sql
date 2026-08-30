create table if not exists public.community_memberships (
  place_id uuid not null
    references public.community_places(id)
    on delete cascade,

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  status text not null default 'active',
  joined_at timestamptz not null default now(),
  left_at timestamptz,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint community_memberships_pkey
    primary key (place_id, user_id),

  constraint community_memberships_status_check
    check (status in ('active', 'left')),

  constraint community_memberships_left_at_check
    check (
      (status = 'active' and left_at is null)
      or
      (status = 'left' and left_at is not null)
    )
);

alter table public.community_memberships
  enable row level security;

create policy "Users can view their own community memberships"
on public.community_memberships
for select
to authenticated
using (user_id = auth.uid());

create policy "Users can create their own community membership"
on public.community_memberships
for insert
to authenticated
with check (user_id = auth.uid());

create or replace function public.set_community_membership_updated_at()
returns trigger
language plpgsql
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

drop trigger if exists community_memberships_set_updated_at
on public.community_memberships;

create trigger community_memberships_set_updated_at
before update on public.community_memberships
for each row
execute function public.set_community_membership_updated_at();

create or replace function public.auto_add_place_creator_as_member()
returns trigger
language plpgsql
security definer
set search_path = public
as $function$
begin
  insert into public.community_memberships (
    place_id,
    user_id,
    status,
    joined_at,
    left_at
  )
  values (
    new.id,
    new.created_by,
    'active',
    now(),
    null
  )
  on conflict (place_id, user_id)
  do update set
    status = 'active',
    left_at = null;

  return new;
end;
$function$;

drop trigger if exists community_places_auto_membership
on public.community_places;

create trigger community_places_auto_membership
after insert on public.community_places
for each row
execute function public.auto_add_place_creator_as_member();

create or replace function public.join_community_place(
  p_place_id uuid
)
returns public.community_memberships
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_membership public.community_memberships;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  if not exists (
    select 1
    from public.community_places
    where id = p_place_id
  ) then
    raise exception 'Community place not found.';
  end if;

  insert into public.community_memberships (
    place_id,
    user_id,
    status,
    joined_at,
    left_at
  )
  values (
    p_place_id,
    auth.uid(),
    'active',
    now(),
    null
  )
  on conflict (place_id, user_id)
  do update set
    status = 'active',
    left_at = null,
    joined_at = case
      when public.community_memberships.status = 'left'
        then now()
      else public.community_memberships.joined_at
    end,
    updated_at = now()
  returning * into v_membership;

  return v_membership;
end;
$function$;

create or replace function public.leave_community_place(
  p_place_id uuid
)
returns public.community_memberships
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_membership public.community_memberships;
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  update public.community_memberships
  set
    status = 'left',
    left_at = now(),
    updated_at = now()
  where place_id = p_place_id
    and user_id = auth.uid()
    and status = 'active'
  returning * into v_membership;

  if not found then
    raise exception 'Active community membership not found.';
  end if;

  return v_membership;
end;
$function$;

create or replace function public.get_community_member_count(
  p_place_id uuid
)
returns integer
language sql
security definer
set search_path = public
as $function$
  select count(*)::integer
  from public.community_memberships
  where place_id = p_place_id
    and status = 'active';
$function$;

revoke all
on function public.join_community_place(uuid)
from public;

grant execute
on function public.join_community_place(uuid)
to authenticated;

revoke all
on function public.leave_community_place(uuid)
from public;

grant execute
on function public.leave_community_place(uuid)
to authenticated;

revoke all
on function public.get_community_member_count(uuid)
from public;

grant execute
on function public.get_community_member_count(uuid)
to authenticated;

insert into public.community_memberships (
  place_id,
  user_id,
  status,
  joined_at,
  left_at
)
select
  id,
  created_by,
  'active',
  created_at,
  null
from public.community_places
where created_by is not null
on conflict (place_id, user_id)
do update set
  status = 'active',
  left_at = null;
