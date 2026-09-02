alter table public.user_profiles
  add column if not exists language_code text not null default 'bn';

alter table public.user_profiles
  add constraint user_profiles_language_code_check
  check (language_code in ('bn', 'hi', 'en'));