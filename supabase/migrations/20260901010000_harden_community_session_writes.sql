-- Harden community session and participant writes.
-- Sensitive writes must go through controlled RPC functions.

drop policy if exists "Users can create their own community sessions"
on public.community_sessions;

drop policy if exists "Users can join community sessions"
on public.session_participants;

drop policy if exists "Users can update their own participation"
on public.session_participants;

drop policy if exists "Users can leave community sessions"
on public.session_participants;
