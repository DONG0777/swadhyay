alter table public.daily_commitments
  drop constraint if exists daily_commitments_status_check;

alter table public.daily_commitments
  add constraint daily_commitments_status_check
  check (status in ('pending', 'completed', 'missed'));
