begin;

-- ============================================================
-- Swadhyay — Surya Namaskar controlled content seed
-- 12 base records + 36 translations
-- Languages: Bengali (bn), English (en), Hindi (hi)
-- ============================================================

-- ------------------------------------------------------------
-- 1. BASE CONTENT — 12 STEPS
-- ------------------------------------------------------------

insert into public.surya_namaskar
    (id, step_number, title, mantra, description, image_url, language_code, is_active)
values
    ('10000000-0000-0000-0000-000000000001', 1,
     'প্রণামাসন',
     'ॐ मित्राय नमः',
     'সূর্য নমস্কারের সূচনা। দুই হাত জোড় করে স্থিরভাবে প্রণাম অবস্থায় দাঁড়ানো।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000002', 2,
     'হস্ত উত্তানাসন',
     'ॐ रवये नमः',
     'হাত উপরে তুলে শরীরকে সামান্য পিছনের দিকে প্রসারিত করা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000003', 3,
     'পদহস্তাসন',
     'ॐ सूर्याय नमः',
     'সামনের দিকে ঝুঁকে হাত মাটির দিকে নিয়ে যাওয়া এবং শরীরকে ভাঁজ করা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000004', 4,
     'অশ্ব সঞ্চালনাসন',
     'ॐ भानवे नमः',
     'এক পা পিছনে নিয়ে সামনের হাঁটু ভাঁজ করে বুক সামনে ও উপরের দিকে প্রসারিত করা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000005', 5,
     'দণ্ডাসন',
     'ॐ खगाय नमः',
     'দুই পা পিছনে নিয়ে শরীরকে মাথা থেকে গোড়ালি পর্যন্ত একটি সরল রেখায় রাখা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000006', 6,
     'অষ্টাঙ্গ নমস্কার',
     'ॐ पूष्णे नमः',
     'দুই হাত, দুই পা, দুই হাঁটু, বুক ও থুতনি—এই আটটি অংশ মাটির সংস্পর্শে আসে।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000007', 7,
     'ভুজঙ্গাসন',
     'ॐ हिरण्यगर्भाय नमः',
     'বুক সামনে ও উপরের দিকে তুলে মেরুদণ্ডকে প্রসারিত করা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000008', 8,
     'পর্বতাসন',
     'ॐ मरीचये नमः',
     'নিতম্ব উপরে তুলে শরীরকে উল্টানো V-আকৃতিতে স্থাপন করা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000009', 9,
     'অশ্ব সঞ্চালনাসন',
     'ॐ आदित्याय नमः',
     'অন্য পা সামনে এনে সামনের হাঁটু ভাঁজ করে বুককে প্রসারিত করা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000010', 10,
     'পদহস্তাসন',
     'ॐ सवित्रे नमः',
     'সামনের দিকে ঝুঁকে দুই পা একত্র করে শরীরকে ভাঁজ করা।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000011', 11,
     'হস্ত উত্তানাসন',
     'ॐ अर्काय नमः',
     'হাত উপরে তুলে শরীরকে প্রসারিত করে সামান্য পিছনের দিকে নেওয়া।',
     null, 'bn', true),

    ('10000000-0000-0000-0000-000000000012', 12,
     'প্রণামাসন',
     'ॐ भास्कराय नमः',
     'দুই হাত জোড় করে স্থির প্রণাম অবস্থায় ফিরে এসে চক্র সম্পূর্ণ করা।',
     null, 'bn', true)

on conflict (id) do update set
    step_number = excluded.step_number,
    title = excluded.title,
    mantra = excluded.mantra,
    description = excluded.description,
    image_url = excluded.image_url,
    language_code = excluded.language_code,
    is_active = excluded.is_active,
    updated_at = now();


-- ------------------------------------------------------------
-- 2. BENGALI TRANSLATIONS
-- ------------------------------------------------------------

insert into public.surya_namaskar_translations
    (id, surya_namaskar_id, language_code, title,
     mantra, mantra_transliteration, mantra_meaning,
     description, instructions, benefits)
values

('20000000-0000-0000-0000-000000000001',
 '10000000-0000-0000-0000-000000000001', 'bn',
 'প্রণামাসন',
 'ॐ मित्राय नमः',
 'Om Mitrāya Namaḥ',
 'সকলের বন্ধু সেই সূর্যকে প্রণাম।',
 'সূর্য নমস্কারের সূচনা ভঙ্গি।',
 'দুই পা একসঙ্গে রেখে সোজা হয়ে দাঁড়ান। বুকের সামনে দুই হাত জোড় করুন।',
 'মনকে স্থির করতে এবং অনুশীলনের জন্য শরীর ও মনকে প্রস্তুত করতে সহায়ক।'),

('20000000-0000-0000-0000-000000000002',
 '10000000-0000-0000-0000-000000000002', 'bn',
 'হস্ত উত্তানাসন',
 'ॐ रवये नमः',
 'Om Ravaye Namaḥ',
 'আলোকোজ্জ্বল ও দীপ্তিমান সূর্যকে প্রণাম।',
 'শরীরের সামনের অংশ প্রসারিত করার ভঙ্গি।',
 'শ্বাস নিয়ে দুই হাত উপরে তুলুন এবং আরামদায়ক সীমায় শরীরকে সামান্য পিছনে প্রসারিত করুন।',
 'বুক ও কাঁধের প্রসারণে সহায়তা করে।'),

('20000000-0000-0000-0000-000000000003',
 '10000000-0000-0000-0000-000000000003', 'bn',
 'পদহস্তাসন',
 'ॐ सूर्याय नमः',
 'Om Sūryāya Namaḥ',
 'সকলের আলোকদাতা সূর্যকে প্রণাম।',
 'সামনের দিকে শরীর ভাঁজ করার ভঙ্গি।',
 'শ্বাস ছেড়ে কোমর থেকে সামনের দিকে ঝুঁকুন। যতটা স্বাচ্ছন্দ্য ততটাই নিচে যান।',
 'পশ্চাৎদেহের পেশি প্রসারণে সহায়তা করে।'),

('20000000-0000-0000-0000-000000000004',
 '10000000-0000-0000-0000-000000000004', 'bn',
 'অশ্ব সঞ্চালনাসন',
 'ॐ भानवे नमः',
 'Om Bhānave Namaḥ',
 'যিনি আলো ছড়ান তাঁকে প্রণাম।',
 'এক পা পিছনে নিয়ে বুককে সামনে ও উপরে প্রসারিত করার ভঙ্গি।',
 'এক পা পিছনে নিন, সামনের হাঁটু ভাঁজ রাখুন এবং বুক সামনে ও উপরের দিকে তুলুন।',
 'পা, কোমর ও বুকের নমনীয়তা উন্নত করতে সহায়ক।'),

('20000000-0000-0000-0000-000000000005',
 '10000000-0000-0000-0000-000000000005', 'bn',
 'দণ্ডাসন',
 'ॐ खगाय नमः',
 'Om Khagāya Namaḥ',
 'যিনি আকাশে বিচরণ করেন তাঁকে প্রণাম।',
 'শরীরকে সরল রেখায় রাখার শক্তিশালী ভঙ্গি।',
 'দুই পা পিছনে নিন এবং মাথা থেকে গোড়ালি পর্যন্ত শরীরকে স্থির সরল রেখায় রাখুন।',
 'হাত, কাঁধ ও শরীরের কেন্দ্রীয় অংশকে সক্রিয় করতে সহায়ক।'),

('20000000-0000-0000-0000-000000000006',
 '10000000-0000-0000-0000-000000000006', 'bn',
 'অষ্টাঙ্গ নমস্কার',
 'ॐ पूष्णे नमः',
 'Om Pūṣṇe Namaḥ',
 'পোষণকারী সূর্যকে প্রণাম।',
 'শরীরের আটটি অংশ মাটির সংস্পর্শে রাখার ভঙ্গি।',
 'হাঁটু নামিয়ে বুক ও থুতনি মাটির দিকে আনুন। কোমর সামান্য উপরে থাকবে।',
 'শরীরের নিয়ন্ত্রণ ও স্থিরতা অনুশীলনে সহায়ক।'),

('20000000-0000-0000-0000-000000000007',
 '10000000-0000-0000-0000-000000000007', 'bn',
 'ভুজঙ্গাসন',
 'ॐ हिरण्यगर्भाय नमः',
 'Om Hiraṇyagarbhāya Namaḥ',
 'সৃষ্টির স্বর্ণময় উৎসকে প্রণাম।',
 'বুক ও মেরুদণ্ড প্রসারিত করার ভঙ্গি।',
 'হাতের সাহায্যে বুক সামনে ও উপরে তুলুন। কাঁধ শিথিল রাখুন এবং কোমরে অতিরিক্ত চাপ দেবেন না।',
 'বুক ও মেরুদণ্ডের প্রসারণে সহায়ক।'),

('20000000-0000-0000-0000-000000000008',
 '10000000-0000-0000-0000-000000000008', 'bn',
 'পর্বতাসন',
 'ॐ मरीचये नमः',
 'Om Marīcaye Namaḥ',
 'সূর্যের রশ্মির অধিপতিকে প্রণাম।',
 'শরীরকে উল্টানো V-আকৃতিতে স্থাপন করার ভঙ্গি।',
 'নিতম্ব উপরে তুলুন এবং হাত ও পা দৃঢ়ভাবে স্থাপন করুন।',
 'কাঁধ, পা ও পশ্চাৎদেহের প্রসারণে সহায়ক।'),

('20000000-0000-0000-0000-000000000009',
 '10000000-0000-0000-0000-000000000009', 'bn',
 'অশ্ব সঞ্চালনাসন',
 'ॐ आदित्याय नमः',
 'Om Ādityāya Namaḥ',
 'অদিতির পুত্র সূর্যকে প্রণাম।',
 'অন্য পা সামনে এনে বুক প্রসারিত করার ভঙ্গি।',
 'অন্য পা সামনে আনুন। সামনের হাঁটু ভাঁজ রাখুন এবং বুককে সামনে ও উপরের দিকে প্রসারিত করুন।',
 'কোমর, পা ও বুকের গতিশীলতায় সহায়ক।'),

('20000000-0000-0000-0000-000000000010',
 '10000000-0000-0000-0000-000000000010', 'bn',
 'পদহস্তাসন',
 'ॐ सवित्रे नमः',
 'Om Savitre Namaḥ',
 'সৃষ্টির প্রেরণাদাতা সূর্যকে প্রণাম।',
 'দুই পা একত্র করে সামনের দিকে ভাঁজ করার ভঙ্গি।',
 'শ্বাস ছেড়ে দুই পা একত্র করুন এবং আরামদায়ক সীমায় সামনের দিকে ঝুঁকুন।',
 'পা ও পশ্চাৎদেহের প্রসারণে সহায়ক।'),

('20000000-0000-0000-0000-000000000011',
 '10000000-0000-0000-0000-000000000011', 'bn',
 'হস্ত উত্তানাসন',
 'ॐ अर्काय नमः',
 'Om Arkāya Namaḥ',
 'আলোকময় সূর্যরূপকে প্রণাম।',
 'দাঁড়িয়ে শরীরকে পুনরায় উপরের দিকে প্রসারিত করার ভঙ্গি।',
 'শ্বাস নিয়ে হাত উপরে তুলুন এবং শরীরকে সামান্য পিছনের দিকে প্রসারিত করুন।',
 'বুক ও কাঁধের প্রসারণে সহায়ক।'),

('20000000-0000-0000-0000-000000000012',
 '10000000-0000-0000-0000-000000000012', 'bn',
 'প্রণামাসন',
 'ॐ भास्कराय नमः',
 'Om Bhāskarāya Namaḥ',
 'যিনি আলো সৃষ্টি করেন সেই সূর্যকে প্রণাম।',
 'চক্রের সমাপ্তি ভঙ্গি।',
 'শ্বাস স্বাভাবিক রেখে দুই হাত বুকের সামনে জোড় করুন এবং স্থির থাকুন।',
 'শরীর ও মনকে শান্ত অবস্থায় ফিরিয়ে আনতে সহায়ক।'),


-- ------------------------------------------------------------
-- 3. ENGLISH TRANSLATIONS
-- ------------------------------------------------------------

('30000000-0000-0000-0000-000000000001',
 '10000000-0000-0000-0000-000000000001', 'en',
 'Prayer Pose',
 'ॐ मित्राय नमः',
 'Om Mitrāya Namaḥ',
 'Salutations to the one who is a friend to all.',
 'The opening posture of Surya Namaskar.',
 'Stand upright with the feet together. Join the palms in front of the chest.',
 'Helps settle the mind and prepare the body for practice.'),

('30000000-0000-0000-0000-000000000002',
 '10000000-0000-0000-0000-000000000002', 'en',
 'Raised Arms Pose',
 'ॐ रवये नमः',
 'Om Ravaye Namaḥ',
 'Salutations to the radiant one.',
 'A posture that lengthens the front of the body.',
 'Inhale, raise both arms and gently extend the body backward within a comfortable range.',
 'Helps open the chest and shoulders.'),

('30000000-0000-0000-0000-000000000003',
 '10000000-0000-0000-0000-000000000003', 'en',
 'Hand-to-Foot Pose',
 'ॐ सूर्याय नमः',
 'Om Sūryāya Namaḥ',
 'Salutations to the source of light.',
 'A forward-folding posture.',
 'Exhale and fold forward from the hips, moving downward only as far as comfortable.',
 'Helps stretch the posterior chain of the body.'),

('30000000-0000-0000-0000-000000000004',
 '10000000-0000-0000-0000-000000000004', 'en',
 'Equestrian Pose',
 'ॐ भानवे नमः',
 'Om Bhānave Namaḥ',
 'Salutations to the one who illuminates.',
 'A posture that extends the chest while one leg moves backward.',
 'Step one leg back, bend the front knee and extend the chest forward and upward.',
 'Helps improve mobility of the legs, hips and chest.'),

('30000000-0000-0000-0000-000000000005',
 '10000000-0000-0000-0000-000000000005', 'en',
 'Stick Pose',
 'ॐ खगाय नमः',
 'Om Khagāya Namaḥ',
 'Salutations to the one who moves through the sky.',
 'A strong posture keeping the body in a straight line.',
 'Step both feet back and maintain a stable straight line from head to heels.',
 'Helps engage the arms, shoulders and core.'),

('30000000-0000-0000-0000-000000000006',
 '10000000-0000-0000-0000-000000000006', 'en',
 'Eight-Limbed Salutation',
 'ॐ पूष्णे नमः',
 'Om Pūṣṇe Namaḥ',
 'Salutations to the nourisher.',
 'A posture in which eight parts of the body touch the ground.',
 'Lower the knees and bring the chest and chin toward the floor while keeping the hips slightly raised.',
 'Helps develop body control and stability.'),

('30000000-0000-0000-0000-000000000007',
 '10000000-0000-0000-0000-000000000007', 'en',
 'Cobra Pose',
 'ॐ हिरण्यगर्भाय नमः',
 'Om Hiraṇyagarbhāya Namaḥ',
 'Salutations to the golden source of creation.',
 'A posture that opens the chest and extends the spine.',
 'Using the hands for support, lift the chest forward and upward without forcing the lower back.',
 'Helps open the chest and extend the spine.'),

('30000000-0000-0000-0000-000000000008',
 '10000000-0000-0000-0000-000000000008', 'en',
 'Mountain Pose',
 'ॐ मरीचये नमः',
 'Om Marīcaye Namaḥ',
 'Salutations to the lord of the rays.',
 'A posture forming an inverted V shape.',
 'Lift the hips upward and ground the hands and feet firmly.',
 'Helps stretch the shoulders, legs and posterior body.'),

('30000000-0000-0000-0000-000000000009',
 '10000000-0000-0000-0000-000000000009', 'en',
 'Equestrian Pose',
 'ॐ आदित्याय नमः',
 'Om Ādityāya Namaḥ',
 'Salutations to the son of Aditi.',
 'The return equestrian posture with the opposite leg forward.',
 'Bring the opposite leg forward, bend the front knee and extend the chest forward and upward.',
 'Helps improve mobility of the hips, legs and chest.'),

('30000000-0000-0000-0000-000000000010',
 '10000000-0000-0000-0000-000000000010', 'en',
 'Hand-to-Foot Pose',
 'ॐ सवित्रे नमः',
 'Om Savitre Namaḥ',
 'Salutations to the divine stimulator and source of inspiration.',
 'A forward fold with the feet together.',
 'Exhale, bring the feet together and fold forward within a comfortable range.',
 'Helps stretch the legs and posterior body.'),

('30000000-0000-0000-0000-000000000011',
 '10000000-0000-0000-0000-000000000011', 'en',
 'Raised Arms Pose',
 'ॐ अर्काय नमः',
 'Om Arkāya Namaḥ',
 'Salutations to the radiant solar form.',
 'A standing posture that lengthens the body upward.',
 'Inhale, raise the arms and gently extend the body backward.',
 'Helps open the chest and shoulders.'),

('30000000-0000-0000-0000-000000000012',
 '10000000-0000-0000-0000-000000000012', 'en',
 'Prayer Pose',
 'ॐ भास्कराय नमः',
 'Om Bhāskarāya Namaḥ',
 'Salutations to the one who creates light.',
 'The closing posture of the cycle.',
 'Return the palms to the chest and stand calmly with natural breathing.',
 'Helps bring the body and mind back to a settled state.'),


-- ------------------------------------------------------------
-- 4. HINDI TRANSLATIONS
-- ------------------------------------------------------------

('40000000-0000-0000-0000-000000000001',
 '10000000-0000-0000-0000-000000000001', 'hi',
 'प्रणामासन',
 'ॐ मित्राय नमः',
 'Om Mitrāya Namaḥ',
 'सबके मित्र सूर्य को नमन।',
 'सूर्य नमस्कार की प्रारंभिक मुद्रा।',
 'दोनों पैरों को साथ रखकर सीधे खड़े हों। छाती के सामने दोनों हथेलियाँ जोड़ें।',
 'मन को स्थिर करने और अभ्यास के लिए शरीर को तैयार करने में सहायक।'),

('40000000-0000-0000-0000-000000000002',
 '10000000-0000-0000-0000-000000000002', 'hi',
 'हस्त उत्तानासन',
 'ॐ रवये नमः',
 'Om Ravaye Namaḥ',
 'प्रकाशमान सूर्य को नमन।',
 'शरीर के सामने के भाग को फैलाने वाली मुद्रा।',
 'श्वास लेते हुए दोनों हाथ ऊपर उठाएँ और आरामदायक सीमा तक शरीर को थोड़ा पीछे फैलाएँ।',
 'छाती और कंधों के विस्तार में सहायक।'),

('40000000-0000-0000-0000-000000000003',
 '10000000-0000-0000-0000-000000000003', 'hi',
 'पादहस्तासन',
 'ॐ सूर्याय नमः',
 'Om Sūryāya Namaḥ',
 'प्रकाश के स्रोत सूर्य को नमन।',
 'आगे की ओर झुकने वाली मुद्रा।',
 'श्वास छोड़ते हुए कूल्हों से आगे झुकें और अपनी सुविधा के अनुसार नीचे जाएँ।',
 'शरीर के पिछले भाग की मांसपेशियों के खिंचाव में सहायक।'),

('40000000-0000-0000-0000-000000000004',
 '10000000-0000-0000-0000-000000000004', 'hi',
 'अश्व संचलनासन',
 'ॐ भानवे नमः',
 'Om Bhānave Namaḥ',
 'प्रकाश फैलाने वाले सूर्य को नमन।',
 'एक पैर पीछे ले जाकर छाती को आगे और ऊपर फैलाने की मुद्रा।',
 'एक पैर पीछे ले जाएँ, आगे के घुटने को मोड़ें और छाती को आगे तथा ऊपर उठाएँ।',
 'पैरों, कूल्हों और छाती की गतिशीलता में सहायक।'),

('40000000-0000-0000-0000-000000000005',
 '10000000-0000-0000-0000-000000000005', 'hi',
 'दण्डासन',
 'ॐ खगाय नमः',
 'Om Khagāya Namaḥ',
 'आकाश में विचरण करने वाले सूर्य को नमन।',
 'शरीर को सीधी रेखा में रखने वाली मुद्रा।',
 'दोनों पैर पीछे ले जाएँ और सिर से एड़ी तक शरीर को स्थिर सीधी रेखा में रखें।',
 'बाहों, कंधों और शरीर के मध्य भाग को सक्रिय करने में सहायक।'),

('40000000-0000-0000-0000-000000000006',
 '10000000-0000-0000-0000-000000000006', 'hi',
 'अष्टांग नमस्कार',
 'ॐ पूष्णे नमः',
 'Om Pūṣṇe Namaḥ',
 'पोषण करने वाले सूर्य को नमन।',
 'शरीर के आठ अंगों को भूमि से स्पर्श कराने वाली मुद्रा।',
 'घुटनों को नीचे रखें और छाती तथा ठुड्डी को भूमि की ओर लाएँ। कूल्हे थोड़े ऊपर रहें।',
 'शरीर के नियंत्रण और स्थिरता के अभ्यास में सहायक।'),

('40000000-0000-0000-0000-000000000007',
 '10000000-0000-0000-0000-000000000007', 'hi',
 'भुजंगासन',
 'ॐ हिरण्यगर्भाय नमः',
 'Om Hiraṇyagarbhāya Namaḥ',
 'सृष्टि के स्वर्णिम स्रोत को नमन।',
 'छाती खोलने और रीढ़ को फैलाने वाली मुद्रा।',
 'हाथों के सहारे छाती को आगे और ऊपर उठाएँ। कमर पर अनावश्यक दबाव न डालें।',
 'छाती खोलने और रीढ़ के विस्तार में सहायक।'),

('40000000-0000-0000-0000-000000000008',
 '10000000-0000-0000-0000-000000000008', 'hi',
 'पर्वतासन',
 'ॐ मरीचये नमः',
 'Om Marīcaye Namaḥ',
 'सूर्य की किरणों के अधिपति को नमन।',
 'शरीर को उल्टे V आकार में रखने वाली मुद्रा।',
 'कूल्हों को ऊपर उठाएँ और हाथों तथा पैरों को स्थिर रखें।',
 'कंधों, पैरों और शरीर के पिछले भाग के खिंचाव में सहायक।'),

('40000000-0000-0000-0000-000000000009',
 '10000000-0000-0000-0000-000000000009', 'hi',
 'अश्व संचलनासन',
 'ॐ आदित्याय नमः',
 'Om Ādityāya Namaḥ',
 'अदिति के पुत्र सूर्य को नमन।',
 'दूसरे पैर को आगे लाकर छाती को फैलाने वाली मुद्रा।',
 'दूसरा पैर आगे लाएँ, आगे के घुटने को मोड़ें और छाती को आगे तथा ऊपर उठाएँ।',
 'कूल्हों, पैरों और छाती की गतिशीलता में सहायक।'),

('40000000-0000-0000-0000-000000000010',
 '10000000-0000-0000-0000-000000000010', 'hi',
 'पादहस्तासन',
 'ॐ सवित्रे नमः',
 'Om Savitre Namaḥ',
 'सृष्टि को प्रेरित करने वाले सूर्य को नमन।',
 'दोनों पैरों को साथ रखकर आगे झुकने की मुद्रा।',
 'श्वास छोड़ते हुए दोनों पैरों को साथ लाएँ और आरामदायक सीमा तक आगे झुकें।',
 'पैरों और शरीर के पिछले भाग के खिंचाव में सहायक।'),

('40000000-0000-0000-0000-000000000011',
 '10000000-0000-0000-0000-000000000011', 'hi',
 'हस्त उत्तानासन',
 'ॐ अर्काय नमः',
 'Om Arkāya Namaḥ',
 'प्रकाशमय सूर्य स्वरूप को नमन।',
 'शरीर को ऊपर की ओर फैलाने वाली खड़ी मुद्रा।',
 'श्वास लेते हुए हाथ ऊपर उठाएँ और शरीर को धीरे से पीछे की ओर फैलाएँ।',
 'छाती और कंधों के विस्तार में सहायक।'),

('40000000-0000-0000-0000-000000000012',
 '10000000-0000-0000-0000-000000000012', 'hi',
 'प्रणामासन',
 'ॐ भास्कराय नमः',
 'Om Bhāskarāya Namaḥ',
 'प्रकाश उत्पन्न करने वाले सूर्य को नमन।',
 'सूर्य नमस्कार चक्र की अंतिम मुद्रा।',
 'हथेलियों को छाती के सामने जोड़ें और सामान्य श्वास के साथ शांत रहें।',
 'शरीर और मन को स्थिर अवस्था में लौटने में सहायक।')

on conflict (id) do update set
    surya_namaskar_id = excluded.surya_namaskar_id,
    language_code = excluded.language_code,
    title = excluded.title,
    mantra = excluded.mantra,
    mantra_transliteration = excluded.mantra_transliteration,
    mantra_meaning = excluded.mantra_meaning,
    description = excluded.description,
    instructions = excluded.instructions,
    benefits = excluded.benefits,
    updated_at = now();


-- ------------------------------------------------------------
-- 5. INTEGRITY CHECKS
-- ------------------------------------------------------------

do $$
declare
    base_count integer;
    translation_count integer;
    duplicate_step_count integer;
    duplicate_language_count integer;
    orphan_count integer;
begin

    select count(*)
    into base_count
    from public.surya_namaskar
    where id between
        '10000000-0000-0000-0000-000000000001'::uuid
        and
        '10000000-0000-0000-0000-000000000012'::uuid;

    if base_count <> 12 then
        raise exception 'Surya Namaskar seed failed: expected 12 base rows, got %', base_count;
    end if;

    select count(*)
    into translation_count
    from public.surya_namaskar_translations
    where id between
        '20000000-0000-0000-0000-000000000001'::uuid
        and
        '40000000-0000-0000-0000-000000000012'::uuid;

    if translation_count <> 36 then
        raise exception 'Surya Namaskar seed failed: expected 36 translation rows, got %', translation_count;
    end if;

    select count(*)
    into duplicate_step_count
    from (
        select step_number
        from public.surya_namaskar
        where id between
            '10000000-0000-0000-0000-000000000001'::uuid
            and
            '10000000-0000-0000-0000-000000000012'::uuid
        group by step_number
        having count(*) <> 1
    ) x;

    if duplicate_step_count <> 0 then
        raise exception 'Surya Namaskar seed failed: duplicate/missing step numbers';
    end if;

    select count(*)
    into duplicate_language_count
    from (
        select surya_namaskar_id, language_code
        from public.surya_namaskar_translations
        where surya_namaskar_id between
            '10000000-0000-0000-0000-000000000001'::uuid
            and
            '10000000-0000-0000-0000-000000000012'::uuid
        group by surya_namaskar_id, language_code
        having count(*) <> 1
    ) x;

    if duplicate_language_count <> 0 then
        raise exception 'Surya Namaskar seed failed: duplicate language records';
    end if;

    select count(*)
    into orphan_count
    from public.surya_namaskar_translations t
    left join public.surya_namaskar s
        on s.id = t.surya_namaskar_id
    where t.surya_namaskar_id between
        '10000000-0000-0000-0000-000000000001'::uuid
        and
        '10000000-0000-0000-0000-000000000012'::uuid
      and s.id is null;

    if orphan_count <> 0 then
        raise exception 'Surya Namaskar seed failed: orphan translations found';
    end if;

end $$;

commit;
