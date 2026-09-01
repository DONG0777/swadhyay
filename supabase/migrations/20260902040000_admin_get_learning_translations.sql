create or replace function public.admin_get_learning_translations(
  p_content_id uuid
)
returns table (
  language_code text,
  title text,
  summary text,
  body text,
  reflection_question text,
  action_prompt text,
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

  if not exists (
    select 1
    from public.learning_contents
    where id = p_content_id
  ) then
    raise exception 'Learning content not found';
  end if;

  return query
  select
    t.language_code,
    t.title,
    t.summary,
    t.body,
    t.reflection_question,
    t.action_prompt,
    t.created_at,
    t.updated_at
  from public.learning_content_translations t
  where t.content_id = p_content_id
  order by case t.language_code
    when 'bn' then 1
    when 'hi' then 2
    when 'en' then 3
    else 4
  end;
end;
$function$;

revoke all on function public.admin_get_learning_translations(uuid) from public;

grant execute on function public.admin_get_learning_translations(uuid) to authenticated;
