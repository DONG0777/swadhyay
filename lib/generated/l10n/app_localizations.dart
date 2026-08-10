import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'bn': {
      // ========== UI টেক্সট ==========
      'appTitle': 'স্বাধ্যায়',
      'welcome': 'স্বাগতম',
      'startQuiz': 'কুইজ শুরু করুন',
      'streak': 'স্ট্রিক',
      'xp': 'এক্সপি',
      'challenge': 'দীপ্ত যাত্রা',
      'circle': 'সার্কেল',
      'checkin': 'চেক-ইন',
      'admin': 'অ্যাডমিন প্যানেল',
      'profile': 'প্রোফাইল',
      'logout': 'লগআউট',
      'guest': 'অতিথি',
      'score': 'স্কোর',
      'share': 'শেয়ার করুন',
      'backHome': 'হোমে ফিরে যান',
      'googleLogin': 'Google দিয়ে লগইন করুন',
      'guestMode': 'অতিথি মোডে প্রবেশ করুন',
      'changeLanguage': 'ভাষা পরিবর্তন করুন',
      'online': 'অনলাইন',
      'offline': 'অফলাইন',

      // ========== চ্যালেঞ্জের বর্ণনা ==========
      'challenge_day_1': 'শুরু: সংকল্প ও লক্ষ্য নির্ধারণ',
      'challenge_day_2': 'শৃঙ্খলা: দৈনিক রুটিন তৈরি',
      'challenge_day_3': 'আত্মবিশ্বাস: নিজের উপর আস্থা',
      'challenge_day_4': 'জ্ঞান: ভালো বই পড়া',
      'challenge_day_5': 'সেবা: সমাজের জন্য কাজ',
      'challenge_day_6': 'স্বাস্থ্য: সূর্য নমস্কার',
      'challenge_day_7': 'ধ্যান: মানসিক শান্তি',
      'challenge_day_8': 'কৃতজ্ঞতা: জীবনের প্রতি কৃতজ্ঞতা',
      'challenge_day_9': 'উদারতা: অন্যদের সাহায্য',
      'challenge_day_10': 'সাহস: ভয়কে জয় করা',
      'challenge_day_11': 'প্রেম: পরিবারের প্রতি যত্ন',
      'challenge_day_12': 'সততা: সত্যের পথে চলা',
      'challenge_day_13': 'পরিশ্রম: লক্ষ্যের জন্য কাজ',
      'challenge_day_14': 'ক্ষমা: ভুলকে মেনে নেওয়া',
      'challenge_day_15': 'ধৈর্য: সময়ের অপেক্ষা',
      'challenge_day_16': 'আশা: ভালো দিনের প্রতীক্ষা',
      'challenge_day_17': 'আত্মনির্ভরতা: নিজের পায়ে দাঁড়ানো',
      'challenge_day_18': 'জ্ঞানার্জন: নতুন কিছু শেখা',
      'challenge_day_19': 'নেতৃত্ব: অন্যদের পথ দেখানো',
      'challenge_day_20': 'ঐক্য: সকলকে সাথে নেওয়া',
      'challenge_day_21': 'পূর্ণতা: ২১ দিনের জয়',

      // ========== দৈনিক স্তম্ভের কন্টেন্ট ==========
      'pillar_stotra_title': 'একাত্মতা স্তোত্র',
      'pillar_stotra_subtitle': 'শুনুন ও অনুভব করুন',
      'pillar_stotra_content': 'ওঁ বিশ্বানি দেব সবিতার দুরিতানি পরাসুভ ।\nযৎ ভদ্রং তন্ন আ সুভ ।\n\n(ঋগ্বেদ ৫.৮২.৫)\n\nঅর্থ: হে সূর্য! আমাদের সকল পাপ দূর করো এবং যা মঙ্গলকর, তা আমাদের দান করো।',

      'pillar_shloka_title': 'শ্লোক',
      'pillar_shloka_subtitle': 'প্রাচীন জ্ঞান',
      'pillar_shloka_content': 'অসতো মা সদ্ গময় ।\nতমসো মা জ্যোতির্গময় ।\nমৃত্যোর্মা অমৃতং গময় ।\n\n(বৃহদারণ্যক উপনিষদ ১.৩.২৮)\n\nঅর্থ: আমাকে অসত্য থেকে সত্যে নিয়ে চলো। অন্ধকার থেকে আলোতে নিয়ে চলো। মৃত্যু থেকে অমৃতত্বে নিয়ে চলো।',

      'pillar_quote_title': 'প্রেরণাদায়ী উক্তি',
      'pillar_quote_subtitle': 'স্বামী বিবেকানন্দ',
      'pillar_quote_content': '"উঠো, জাগো এবং লক্ষ্য না পাওয়া পর্যন্ত থামো না।"\n\n- স্বামী বিবেকানন্দ\n\nআপনার মধ্যে অপরিমেয় শক্তি আছে। বিশ্বাস করুন, নিজের উপর আস্থা রাখুন।',

      'pillar_book_title': 'বইয়ের স্পটলাইট',
      'pillar_book_subtitle': 'আজকের পাঠ',
      'pillar_book_content': '📖 **আরএসএস: কী ও কেন?**\n\nলেখক: ড. মানবেন্দ্র নাথ রায়\n\nসংক্ষিপ্ত বিবরণ: এই বইটি রাষ্ট্রীয় স্বয়ংsevক সংঘের (আরএসএস) আদর্শ, কর্মপদ্ধতি ও ভারতীয় সংস্কৃতিতে এর অবদান সম্পর্কে আলোচনা করে। স্বায়ংসেবকের জীবনদর্শন ও সংগঠনের লক্ষ্য বুঝতে এটি অপরিহার্য পাঠ্য।',

      'pillar_surya_title': 'সূর্য নমস্কার',
      'pillar_surya_subtitle': 'দৈনিক ১২টি সেট',
      'pillar_surya_content': '🧘 **সূর্য নমস্কার**\n\nদৈনিক ১২টি সেট করুন।\nপ্রতিটি সেটে ১২টি আসন থাকে।\n\nসূর্য নমস্কার শারীরিক ও মানসিক স্বাস্থ্যের জন্য অত্যন্ত উপকারী। এটি সকালে খালি পেটে করার পরামর্শ দেওয়া হয়।',

      'pillar_duty_title': 'নাগরিক কর্তব্য',
      'pillar_duty_subtitle': 'আজকের দায়িত্ব',
      'pillar_duty_content': '🇮🇳 **আজকের কর্তব্য:**\n\n১. পরিবেশের জন্য একটি গাছ লাগান।\n২. কোনো অভাবী ব্যক্তিকে খাদ্য দান করুন।\n৩. নিজের এলাকা পরিষ্কার রাখুন।\n\n"সেবা পরমো ধর্ম" - এই বাণী স্মরণ রাখুন।',
    
  'tagline': 'দৈনিক আত্মশিক্ষা ও সাংস্কৃতিক সচেতনতা',},
    'hi': {
      // ========== UI टेक्स्ट ==========
      'appTitle': 'स्वाध्याय',
      'welcome': 'स्वागत है',
      'startQuiz': 'क्विज़ शुरू करें',
      'streak': 'स्ट्रीक',
      'xp': 'एक्सपी',
      'challenge': 'दीप्त यात्रा',
      'circle': 'सर्कल',
      'checkin': 'चेक-इन',
      'admin': 'एडमिन पैनल',
      'profile': 'प्रोफ़ाइल',
      'logout': 'लॉगआउट',
      'guest': 'अतिथि',
      'score': 'स्कोर',
      'share': 'शेयर करें',
      'backHome': 'होम पर वापस जाएं',
      'googleLogin': 'Google से लॉगिन करें',
      'guestMode': 'अतिथि मोड में प्रवेश करें',
      'changeLanguage': 'भाषा बदलें',
      'online': 'ऑनलाइन',
      'offline': 'ऑफलाइन',

      // ========== चैलेंज विवरण ==========
      'challenge_day_1': 'शुरुआत: संकल्प और लक्ष्य निर्धारण',
      'challenge_day_2': 'अनुशासन: दैनिक दिनचर्या बनाना',
      'challenge_day_3': 'आत्मविश्वास: स्वयं पर भरोसा',
      'challenge_day_4': 'ज्ञान: अच्छी किताबें पढ़ना',
      'challenge_day_5': 'सेवा: समाज के लिए काम',
      'challenge_day_6': 'स्वास्थ्य: सूर्य नमस्कार',
      'challenge_day_7': 'ध्यान: मानसिक शांति',
      'challenge_day_8': 'कृतज्ञता: जीवन के प्रति आभार',
      'challenge_day_9': 'उदारता: दूसरों की मदद',
      'challenge_day_10': 'साहस: डर को जीतना',
      'challenge_day_11': 'प्रेम: परिवार की देखभाल',
      'challenge_day_12': 'ईमानदारी: सत्य के पथ पर चलना',
      'challenge_day_13': 'परिश्रम: लक्ष्य के लिए काम',
      'challenge_day_14': 'क्षमा: गलती स्वीकार करना',
      'challenge_day_15': 'धैर्य: समय की प्रतीक्षा',
      'challenge_day_16': 'आशा: अच्छे दिनों की प्रतीक्षा',
      'challenge_day_17': 'आत्मनिर्भरता: अपने पैरों पर खड़े होना',
      'challenge_day_18': 'ज्ञानार्जन: कुछ नया सीखना',
      'challenge_day_19': 'नेतृत्व: दूसरों को रास्ता दिखाना',
      'challenge_day_20': 'एकता: सभी को साथ लेकर चलना',
      'challenge_day_21': 'पूर्णता: 21 दिन की जीत',

      // ========== दैनिक स्तंभ सामग्री ==========
      'pillar_stotra_title': 'एकात्मता स्तोत्र',
      'pillar_stotra_subtitle': 'सुनें और अनुभव करें',
      'pillar_stotra_content': 'ॐ विश्वानि देव सविता दुरितानि परासुव ।\nयत् भद्रं तन्न आ सुव ।\n\n(ऋग्वेद ५.८२.५)\n\nअर्थ: हे सूर्य! हमारे सभी पापों को दूर करो और जो कल्याणकारी है, वह हमें प्रदान करो।',

      'pillar_shloka_title': 'श्लोक',
      'pillar_shloka_subtitle': 'प्राचीन ज्ञान',
      'pillar_shloka_content': 'असतो मा सद्गमय ।\nतमसो मा ज्योतिर्गमय ।\nमृत्योर्मा अमृतं गमय ।\n\n(बृहदारण्यक उपनिषद १.३.२८)\n\nअर्थ: मुझे असत्य से सत्य की ओर ले चलो। अंधकार से प्रकाश की ओर ले चलो। मृत्यु से अमरत्व की ओर ले चलो।',

      'pillar_quote_title': 'प्रेरक वचन',
      'pillar_quote_subtitle': 'स्वामी विवेकानंद',
      'pillar_quote_content': '"उठो, जागो और लक्ष्य प्राप्त न होने तक मत रुको।"\n\n- स्वामी विवेकानंद\n\nआप में अपार शक्ति है। विश्वास करें, अपने आप पर भरोसा रखें।',

      'pillar_book_title': 'पुस्तक स्पॉटलाइट',
      'pillar_book_subtitle': 'आज का पाठ',
      'pillar_book_content': '📖 **RSS: क्या और क्यों?**\n\nलेखक: डॉ. मानवेंद्र नाथ रॉय\n\nसंक्षिप्त विवरण: यह पुस्तक राष्ट्रीय स्वयंसेवक संघ (RSS) के आदर्श, कार्यप्रणाली और भारतीय संस्कृति में इसके योगदान पर चर्चा करती है। स्वयंसेवक के जीवन दर्शन और संगठन के लक्ष्य को समझने के लिए यह आवश्यक पाठ है।',

      'pillar_surya_title': 'सूर्य नमस्कार',
      'pillar_surya_subtitle': 'दैनिक 12 सेट',
      'pillar_surya_content': '🧘 **सूर्य नमस्कार**\n\nदैनिक 12 सेट करें।\nप्रत्येक सेट में 12 आसन होते हैं।\n\nसूर्य नमस्कार शारीरिक और मानसिक स्वास्थ्य के लिए अत्यंत लाभकारी है। इसे सुबह खाली पेट करने की सलाह दी जाती है।',

      'pillar_duty_title': 'नागरिक कर्तव्य',
      'pillar_duty_subtitle': 'आज की जिम्मेदारी',
      'pillar_duty_content': '🇮🇳 **आज के कर्तव्य:**\n\n१. पर्यावरण के लिए एक पेड़ लगाएं।\n२. किसी जरूरतमंद को भोजन दान करें।\n३. अपने क्षेत्र को साफ रखें।\n\n"सेवा परमो धर्म" - इस वाक्य को याद रखें।',
    
  'tagline': 'दैनिक आत्म-शिक्षा और सांस्कृतिक जागरूकता',},
    'en': {
      // ========== UI Text ==========
      'appTitle': 'Swadhyay',
      'welcome': 'Welcome',
      'startQuiz': 'Start Quiz',
      'streak': 'Streak',
      'xp': 'XP',
      'challenge': 'Dipto Jatra',
      'circle': 'Circle',
      'checkin': 'Check-in',
      'admin': 'Admin Panel',
      'profile': 'Profile',
      'logout': 'Logout',
      'guest': 'Guest',
      'score': 'Score',
      'share': 'Share',
      'backHome': 'Back to Home',
      'googleLogin': 'Login with Google',
      'guestMode': 'Enter Guest Mode',
      'changeLanguage': 'Change Language',
      'online': 'Online',
      'offline': 'Offline',

      // ========== Challenge Descriptions ==========
      'challenge_day_1': 'Start: Commitment and goal setting',
      'challenge_day_2': 'Discipline: Create daily routine',
      'challenge_day_3': 'Confidence: Trust yourself',
      'challenge_day_4': 'Knowledge: Read good books',
      'challenge_day_5': 'Service: Work for society',
      'challenge_day_6': 'Health: Surya Namaskar',
      'challenge_day_7': 'Meditation: Mental peace',
      'challenge_day_8': 'Gratitude: Be thankful for life',
      'challenge_day_9': 'Generosity: Help others',
      'challenge_day_10': 'Courage: Conquer fear',
      'challenge_day_11': 'Love: Care for family',
      'challenge_day_12': 'Honesty: Walk the path of truth',
      'challenge_day_13': 'Hard work: Work towards goals',
      'challenge_day_14': 'Forgiveness: Accept mistakes',
      'challenge_day_15': 'Patience: Wait for the right time',
      'challenge_day_16': 'Hope: Await good days',
      'challenge_day_17': 'Self-reliance: Stand on your own feet',
      'challenge_day_18': 'Learning: Learn something new',
      'challenge_day_19': 'Leadership: Show others the way',
      'challenge_day_20': 'Unity: Take everyone together',
      'challenge_day_21': 'Completion: 21-day victory',

      // ========== Daily Pillars Content ==========
      'pillar_stotra_title': 'Ekatmata Stotra',
      'pillar_stotra_subtitle': 'Listen and feel',
      'pillar_stotra_content': 'Om Vishwani Deva Savita Duritani Parasuva ।\nYat Bhadram Tan Na A Suva ।\n\n(Rigveda 5.82.5)\n\nMeaning: O Sun! Remove all our sins and bestow upon us what is good and beneficial.',

      'pillar_shloka_title': 'Shloka',
      'pillar_shloka_subtitle': 'Ancient Wisdom',
      'pillar_shloka_content': 'Asato Ma Sadgamaya ।\nTamaso Ma Jyotirgamaya ।\nMrityorma Amritam Gamaya ।\n\n(Brihadaranyaka Upanishad 1.3.28)\n\nMeaning: Lead me from untruth to truth. Lead me from darkness to light. Lead me from mortality to immortality.',

      'pillar_quote_title': 'Inspirational Quote',
      'pillar_quote_subtitle': 'Swami Vivekananda',
      'pillar_quote_content': '"Arise, awake and stop not till the goal is reached."\n\n- Swami Vivekananda\n\nThere is immense power within you. Believe, have faith in yourself.',

      'pillar_book_title': 'Book Spotlight',
      'pillar_book_subtitle': 'Today\'s Reading',
      'pillar_book_content': '📖 **RSS: What and Why?**\n\nAuthor: Dr. Manavendra Nath Roy\n\nBrief Description: This book discusses the ideals, methodology, and contribution of the Rashtriya Swayamsevak Sangh (RSS) to Indian culture. It is an essential read to understand the volunteer\'s philosophy and the organization\'s goals.',

      'pillar_surya_title': 'Surya Namaskar',
      'pillar_surya_subtitle': 'Daily 12 sets',
      'pillar_surya_content': '🧘 **Surya Namaskar**\n\nDo 12 sets daily.\nEach set consists of 12 asanas.\n\nSurya Namaskar is highly beneficial for physical and mental health. It is recommended to do it in the morning on an empty stomach.',

      'pillar_duty_title': 'Civic Duty',
      'pillar_duty_subtitle': 'Today\'s Responsibility',
      'pillar_duty_content': '🇮🇳 **Today\'s Duties:**\n\n1. Plant a tree for the environment.\n2. Donate food to a needy person.\n3. Keep your surroundings clean.\n\n"Seva Paramo Dharma" - Remember this saying.',
    
  'tagline': 'Daily self-study and cultural awareness',}
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key]!;
  }

  // ========== UI ==========
  String get appTitle => translate('appTitle');
    String get tagline => translate('tagline');
  String get welcome => translate('welcome');
  String get startQuiz => translate('startQuiz');
  String get streak => translate('streak');
  String get xp => translate('xp');
  String get challenge => translate('challenge');
  String get circle => translate('circle');
  String get checkin => translate('checkin');
  String get admin => translate('admin');
  String get profile => translate('profile');
  String get logout => translate('logout');
  String get guest => translate('guest');
  String get score => translate('score');
  String get share => translate('share');
  String get backHome => translate('backHome');
  String get googleLogin => translate('googleLogin');
  String get guestMode => translate('guestMode');
  String get changeLanguage => translate('changeLanguage');
  String get online => translate('online');
  String get offline => translate('offline');

  // ========== চ্যালেঞ্জ ==========
  String challengeDay(int day) => translate('challenge_day_$day');

  // ========== দৈনিক স্তম্ভ ==========
  String get pillarStotraTitle => translate('pillar_stotra_title');
  String get pillarStotraSubtitle => translate('pillar_stotra_subtitle');
  String get pillarStotraContent => translate('pillar_stotra_content');

  String get pillarShlokaTitle => translate('pillar_shloka_title');
  String get pillarShlokaSubtitle => translate('pillar_shloka_subtitle');
  String get pillarShlokaContent => translate('pillar_shloka_content');

  String get pillarQuoteTitle => translate('pillar_quote_title');
  String get pillarQuoteSubtitle => translate('pillar_quote_subtitle');
  String get pillarQuoteContent => translate('pillar_quote_content');

  String get pillarBookTitle => translate('pillar_book_title');
  String get pillarBookSubtitle => translate('pillar_book_subtitle');
  String get pillarBookContent => translate('pillar_book_content');

  String get pillarSuryaTitle => translate('pillar_surya_title');
  String get pillarSuryaSubtitle => translate('pillar_surya_subtitle');
  String get pillarSuryaContent => translate('pillar_surya_content');

  String get pillarDutyTitle => translate('pillar_duty_title');
  String get pillarDutySubtitle => translate('pillar_duty_subtitle');
  String get pillarDutyContent => translate('pillar_duty_content');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['bn', 'hi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

