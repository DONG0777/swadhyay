create or replace function public.admin_create_learning_content(
  p_content_kind text,
  p_category text,
  p_source_title text default null,
  p_source_author text default null,
  p_source_reference text default null,
  p_source_url text default null,
  p_estimated_minutes smallint default 5,
  p_difficulty text default 'easy'
)
returns uuid
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_content_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Not authorized';
  end if;

  insert into public.learning_contents (
    created_by,
    content_kind,
    category,
    source_title,
    source_author,
    source_reference,
    source_url,
    estimated_minutes,
    difficulty,
    status
  )
  values (
    auth.uid(),
    p_content_kind,
    p_category,
    p_source_title,
    p_source_author,
    p_source_reference,
    p_source_url,
    p_estimated_minutes,
    p_difficulty,
    'draft'
  )
  returning id into v_content_id;

  return v_content_id;
end;
$function$;


create or replace function public.admin_update_learning_content(
  p_content_id uuid,
  p_content_kind text,
  p_category text,
  p_source_title text default null,
  p_source_author text default null,
  p_source_reference text default null,
  p_source_url text default null,
  p_estimated_minutes smallint default 5,
  p_difficulty text default 'easy'
)
returns boolean
language plpgsql
security definer
set search_path = public
as $function$
begin
  if not public.is_admin() then
    raise exception 'Not authorized';
  end if;

  update public.learning_contents
  set
    content_kind = p_content_kind,
    category = p_category,
    source_title = p_source_title,
    source_author = p_source_author,
    source_reference = p_source_reference,
    source_url = p_source_url,
    estimated_minutes = p_estimated_minutes,
    difficulty = p_difficulty
  where id = p_content_id;

  return found;
end;
$function$;


create or replace function public.admin_set_learning_content_status(
  p_content_id uuid,
  p_status text
)
returns boolean
language plpgsql
security definer
set search_path = public
as $function$
begin
  if not public.is_admin() then
    raise exception 'Not authorized';
  end if;

  if p_status not in (
    'draft',
    'submitted',
    'published',
    'archived'
  ) then
    raise exception 'Invalid learning content status';
  end if;

  update public.learning_contents
  set
    status = p_status,
    published_at = case
      when p_status = 'published' then coalesce(published_at, now())
      else published_at
    end
  where id = p_content_id;

  return found;
end;
$function$;


revoke all on function public.admin_create_learning_content(
  text,
  text,
  text,
  text,
  text,
  text,
  smallint,
  text
) from public;

revoke all on function public.admin_update_learning_content(
  uuid,
  text,
  text,
  text,
  text,
  text,
  text,
  smallint,
  text
) from public;

revoke all on function public.admin_set_learning_content_status(
  uuid,
  text
) from public;


grant execute on function public.admin_create_learning_content(
  text,
  text,
  text,
  text,
  text,
  text,
  smallint,
  text
) to authenticated;

grant execute on function public.admin_update_learning_content(
  uuid,
  text,
  text,
  text,
  text,
  text,
  text,
  smallint,
  text
) to authenticated;

grant execute on function public.admin_set_learning_content_status(
  uuid,
  text
) to authenticated;