create or replace function public.admin_list_learning_contents(
  p_limit integer default 50,
  p_offset integer default 0
)
returns table (
  id uuid,
  content_kind text,
  category text,
  source_title text,
  source_author text,
  source_reference text,
  source_url text,
  estimated_minutes smallint,
  difficulty text,
  status text,
  published_at timestamptz,
  created_at timestamptz,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $function$
begin
  if not public.is_admin() then
    raise exception 'Not authorized';
  end if;

  if p_limit < 1 or p_limit > 100 then
    raise exception 'Invalid limit';
  end if;

  if p_offset < 0 then
    raise exception 'Invalid offset';
  end if;

  return query
  select
    lc.id,
    lc.content_kind,
    lc.category,
    lc.source_title,
    lc.source_author,
    lc.source_reference,
    lc.source_url,
    lc.estimated_minutes,
    lc.difficulty,
    lc.status,
    lc.published_at,
    lc.created_at,
    lc.updated_at
  from public.learning_contents lc
  order by lc.created_at desc
  limit p_limit
  offset p_offset;
end;
$function$;


revoke all on function public.admin_list_learning_contents(
  integer,
  integer
) from public;

grant execute on function public.admin_list_learning_contents(
  integer,
  integer
) to authenticated;
