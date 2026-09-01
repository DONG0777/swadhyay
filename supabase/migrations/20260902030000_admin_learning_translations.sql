create or replace function public.admin_upsert_learning_translation(
  p_content_id uuid,
  p_language_code text,
  p_title text,
  p_summary text default null,
  p_body text default null,
  p_reflection_question text default null,
  p_action_prompt text default null
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

  if p_language_code not in ('bn', 'hi', 'en') then
    raise exception 'Invalid language';
  end if;

  if not exists (
    select 1
    from public.learning_contents
    where id = p_content_id
  ) then
    raise exception 'Learning content not found';
  end if;

  insert into public.learning_content_translations (
    content_id,
    language_code,
    title,
    summary,
    body,
    reflection_question,
    action_prompt
  )
  values (
    p_content_id,
    p_language_code,
    btrim(p_title),
    nullif(btrim(p_summary), ''),
    nullif(btrim(p_body), ''),
    nullif(btrim(p_reflection_question), ''),
    nullif(btrim(p_action_prompt), '')
  )
  on conflict (content_id, language_code)
  do update set
    title = excluded.title,
    summary = excluded.summary,
    body = excluded.body,
    reflection_question = excluded.reflection_question,
    action_prompt = excluded.action_prompt,
    updated_at = now();

  return true;
end;
$function$;

revoke all on function public.admin_upsert_learning_translation(
  uuid,
  text,
  text,
  text,
  text,
  text,
  text
) from public;

grant execute on function public.admin_upsert_learning_translation(
  uuid,
  text,
  text,
  text,
  text,
  text,
  text
) to authenticated;
