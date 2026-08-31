-- Harden community session leave.
-- Participant deletion must go through a controlled RPC.

create or replace function public.leave_community_session(
  p_session_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $function$
begin
  if auth.uid() is null then
    raise exception 'User is not signed in.';
  end if;

  delete from public.session_participants
  where session_id = p_session_id
    and user_id = auth.uid();
end;
$function$;

revoke all
on function public.leave_community_session(uuid)
from public;

grant execute
on function public.leave_community_session(uuid)
to authenticated;
