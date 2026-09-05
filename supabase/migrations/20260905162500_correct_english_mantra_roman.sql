update public.surya_namaskar_translations
set mantra = case surya_namaskar_id
  when '10000000-0000-0000-0000-000000000001' then 'Om Mitraya Namah'
  when '10000000-0000-0000-0000-000000000002' then 'Om Ravaye Namah'
  when '10000000-0000-0000-0000-000000000003' then 'Om Suryaya Namah'
  when '10000000-0000-0000-0000-000000000004' then 'Om Bhanave Namah'
  when '10000000-0000-0000-0000-000000000005' then 'Om Khagaya Namah'
  when '10000000-0000-0000-0000-000000000006' then 'Om Pushne Namah'
  when '10000000-0000-0000-0000-000000000007' then 'Om Hiranyagarbhaya Namah'
  when '10000000-0000-0000-0000-000000000008' then 'Om Marichaye Namah'
  when '10000000-0000-0000-0000-000000000009' then 'Om Adityaya Namah'
  when '10000000-0000-0000-0000-000000000010' then 'Om Savitre Namah'
  when '10000000-0000-0000-0000-000000000011' then 'Om Arkaya Namah'
  when '10000000-0000-0000-0000-000000000012' then 'Om Bhaskaraya Namah'
end
where language_code = 'en';
