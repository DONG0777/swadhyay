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
      'appTitle': 'স্বাধ্যায়',
      'tagline': 'দৈনিক আত্মশিক্ষা ও সাংস্কৃতিক সচেতনতা',
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
      'requirements': '📋 প্রয়োজনীয়তা',
      'benefits': '🌟 সুবিধা',
      'iUnderstand': '✅ বুঝেছি',

      // চ্যালেঞ্জের বর্ণনা
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

      // সার্কেল গাইড
      'familyCircleTitle': '🏠 পারিবারিক সার্কেল',
      'familyCircleDesc': 'পরিবার ও আত্মীয়দের জন্য একটি প্রাইভেট সার্কেল।',
      'familyCircleReq': '✅ শুধু ইনভাইটের মাধ্যমে যোগ দিন।\n✅ সর্বনিম্ন ২ জন সদস্য।\n✅ জিপিএস ভেরিফিকেশন প্রয়োজন নেই।',
      'familyCircleBen': '🌟 পরিবারের সাথে নিয়মিত চর্চা করুন।\n🌟 স্ট্রিক ও এক্সপি সংগ্রহ করুন।\n🌟 নিরাপদ ও ব্যক্তিগত পরিবেশ।',

      'socialCircleTitle': '🤝 সামাজিক সার্কেল',
      'socialCircleDesc': 'বন্ধু, প্রতিবেশী বা সহকর্মীদের জন্য একটি খোলা সার্কেল।',
      'socialCircleReq': '✅ জিপিএস ভেরিফিকেশন প্রয়োজন।\n✅ সর্বনিম্ন ৩ জন সদস্য।\n✅ অ্যাডমিন অনুমোদন প্রয়োজন।',
      'socialCircleBen': '🌟 নতুন মানুষদের সাথে পরিচিত হন।\n🌟 গ্রুপ অ্যাক্টিভিটি করুন।\n🌟 কমিউনিটি তৈরি করুন।',

      'universalCircleTitle': '🌍 সার্বিক সার্কেল',
      'universalCircleDesc': 'সবার জন্য উন্মুক্ত একটি পাবলিক সার্কেল।',
      'universalCircleReq': '✅ জিপিএস ভেরিফিকেশন আবশ্যক।\n✅ ২টি সামাজিক সার্কেলের অনুমোদন প্রয়োজন।\n✅ সর্বনিম্ন ৫ জন সদস্য।\n✅ ৬টি ভোট প্রয়োজন।',
      'universalCircleBen': '🌟 বড় কমিউনিটির সাথে সংযুক্ত হন।\n🌟 ইভেন্ট ও মিটআপ আয়োজন করুন।\n🌟 লিডারশিপের সুযোগ।',
    },
    'hi': {
      'appTitle': 'स्वाध्याय',
      'tagline': 'दैनिक आत्म-शिक्षा और सांस्कृतिक जागरूकता',
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
      'requirements': '📋 आवश्यकताएँ',
      'benefits': '🌟 लाभ',
      'iUnderstand': '✅ समझ गया',

      // चैलेंज विवरण
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

      // सर्कल गाइड
      'familyCircleTitle': '🏠 पारिवारिक सर्कल',
      'familyCircleDesc': 'परिवार और रिश्तेदारों के लिए एक निजी सर्कल।',
      'familyCircleReq': '✅ केवल आमंत्रण द्वारा शामिल हों।\n✅ न्यूनतम 2 सदस्य।\n✅ जीपीएस सत्यापन की आवश्यकता नहीं।',
      'familyCircleBen': '🌟 परिवार के साथ नियमित अभ्यास करें।\n🌟 स्ट्रीक और एक्सपी इकट्ठा करें।\n🌟 सुरक्षित और निजी वातावरण।',

      'socialCircleTitle': '🤝 सामाजिक सर्कल',
      'socialCircleDesc': 'मित्रों, पड़ोसियों या सहकर्मियों के लिए एक खुला सर्कल।',
      'socialCircleReq': '✅ जीपीएस सत्यापन आवश्यक।\n✅ न्यूनतम 3 सदस्य।\n✅ एडमिन अनुमोदन आवश्यक।',
      'socialCircleBen': '🌟 नए लोगों से मिलें।\n🌟 समूह गतिविधियाँ करें।\n🌟 समुदाय बनाएं।',

      'universalCircleTitle': '🌍 सार्वभौमिक सर्कल',
      'universalCircleDesc': 'सभी के लिए खुला एक सार्वजनिक सर्कल।',
      'universalCircleReq': '✅ जीपीएस सत्यापन अनिवार्य।\n✅ 2 सामाजिक सर्कल की स्वीकृति आवश्यक।\n✅ न्यूनतम 5 सदस्य।\n✅ 6 वोट आवश्यक।',
      'universalCircleBen': '🌟 बड़े समुदाय से जुड़ें।\n🌟 इवेंट और मीटअप आयोजित करें।\n🌟 नेतृत्व के अवसर।',
    },
    'en': {
      'appTitle': 'Swadhyay',
      'tagline': 'Daily self-study and cultural awareness',
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
      'requirements': '📋 Requirements',
      'benefits': '🌟 Benefits',
      'iUnderstand': '✅ I Understand',

      // Challenge descriptions
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

      // Circle Guide
      'familyCircleTitle': '🏠 Family Circle',
      'familyCircleDesc': 'A private circle for family and relatives.',
      'familyCircleReq': '✅ Join only by invite.\n✅ Minimum 2 members.\n✅ No GPS verification required.',
      'familyCircleBen': '🌟 Regular practice with family.\n🌟 Collect streaks and XP.\n🌟 Safe and private environment.',

      'socialCircleTitle': '🤝 Social Circle',
      'socialCircleDesc': 'An open circle for friends, neighbors, or colleagues.',
      'socialCircleReq': '✅ GPS verification required.\n✅ Minimum 3 members.\n✅ Admin approval required.',
      'socialCircleBen': '🌟 Meet new people.\n🌟 Do group activities.\n🌟 Build a community.',

      'universalCircleTitle': '🌍 Universal Circle',
      'universalCircleDesc': 'A public circle open to everyone.',
      'universalCircleReq': '✅ GPS verification mandatory.\n✅ Requires approval from 2 social circles.\n✅ Minimum 5 members.\n✅ 6 votes required.',
      'universalCircleBen': '🌟 Connect with a larger community.\n🌟 Organize events and meetups.\n🌟 Leadership opportunities.',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key]!;
  }

  // UI Getters
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
  String get requirements => translate('requirements');
  String get benefits => translate('benefits');
  String get iUnderstand => translate('iUnderstand');

  // চ্যালেঞ্জের দিন
  String challengeDay(int day) => translate('challenge_day_$day');

  // Circle Guide Getters
  String get familyCircleTitle => translate('familyCircleTitle');
  String get familyCircleDesc => translate('familyCircleDesc');
  String get familyCircleReq => translate('familyCircleReq');
  String get familyCircleBen => translate('familyCircleBen');

  String get socialCircleTitle => translate('socialCircleTitle');
  String get socialCircleDesc => translate('socialCircleDesc');
  String get socialCircleReq => translate('socialCircleReq');
  String get socialCircleBen => translate('socialCircleBen');

  String get universalCircleTitle => translate('universalCircleTitle');
  String get universalCircleDesc => translate('universalCircleDesc');
  String get universalCircleReq => translate('universalCircleReq');
  String get universalCircleBen => translate('universalCircleBen');
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
