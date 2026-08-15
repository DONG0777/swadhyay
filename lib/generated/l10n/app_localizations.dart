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
      // Challenge days
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
      // Universal Proposal
      'universalProposal': '🌍 সার্বিক প্রস্তাব',
      'newProposal': 'নতুন প্রস্তাব দিন',
      'proposalName': 'সার্কেলের নাম *',
      'proposalDescription': 'বিবরণ',
      'proposalLatitude': 'ল্যাটিটিউড *',
      'proposalLongitude': 'লংগিটিউড *',
      'gpsVerify': '📍 GPS ভেরিফাই করুন',
      'gpsVerified': '✅ GPS ভেরিফাই করা হয়েছে',
      'gpsVerifyAgain': 'পুনরায় ভেরিফাই করুন',
      'gpsRequired': '📍 এই লোকেশনে গিয়ে ভেরিফাই করুন',
      'submitProposal': '📤 প্রস্তাব জমা দিন',
      'proposalSubmitted': '✅ প্রস্তাব জমা হয়েছে!',
      'proposalNameRequired': '❌ নাম দিন',
      'gpsFirst': '❌ প্রথমে GPS ভেরিফাই করুন',
      'noProposals': 'কোনো প্রস্তাব নেই',
      'beFirst': 'আপনি প্রথম সার্বিক সার্কেলের প্রস্তাব দিন!',
      'proposalStatus': '📌 স্ট্যাটাস:',
      'proposalVotes': 'ভোট',
      'proposalSupport': 'সমর্থন',
      'proposalOppose': 'বিপক্ষে',
      'loginToVote': '🔑 লগইন করে ভোট দিন',
      'alreadyVoted': '❌ আপনি ইতিমধ্যে ভোট দিয়েছেন!',
      'voteSupport': '✅ সমর্থন দিয়েছেন!',
      'voteOppose': '❌ বিপক্ষে ভোট দিয়েছেন!',
      'loginRequired': '🔑 দয়া করে লগইন করুন',
      'proposalActive': '✅ সক্রিয়',
      'proposalRejected': '❌ প্রত্যাখ্যাত',
      'proposalPending': '⏳ pending',
      'proposalGpsVerified': '📍 GPS verified',
      'proposalVouching': '🤝 vouching',
      'proposalVoting': '🗳️ voting',
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
      // Challenge days
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
      // Universal Proposal
      'universalProposal': '🌍 सार्वभौमिक प्रस्ताव',
      'newProposal': 'नया प्रस्ताव दें',
      'proposalName': 'सर्कल का नाम *',
      'proposalDescription': 'विवरण',
      'proposalLatitude': 'अक्षांश *',
      'proposalLongitude': 'देशांतर *',
      'gpsVerify': '📍 GPS सत्यापित करें',
      'gpsVerified': '✅ GPS सत्यापित किया गया',
      'gpsVerifyAgain': 'पुनः सत्यापित करें',
      'gpsRequired': '📍 इस स्थान पर जाकर सत्यापित करें',
      'submitProposal': '📤 प्रस्ताव जमा करें',
      'proposalSubmitted': '✅ प्रस्ताव जमा हो गया!',
      'proposalNameRequired': '❌ नाम दें',
      'gpsFirst': '❌ पहले GPS सत्यापित करें',
      'noProposals': 'कोई प्रस्ताव नहीं',
      'beFirst': 'आप पहला सार्वभौमिक सर्कल प्रस्ताव दें!',
      'proposalStatus': '📌 स्थिति:',
      'proposalVotes': 'वोट',
      'proposalSupport': 'समर्थन',
      'proposalOppose': 'विरोध',
      'loginToVote': '🔑 वोट करने के लिए लॉगिन करें',
      'alreadyVoted': '❌ आप पहले ही वोट कर चुके हैं!',
      'voteSupport': '✅ आपने समर्थन किया!',
      'voteOppose': '❌ आपने विरोध किया!',
      'loginRequired': '🔑 कृपया लॉगिन करें',
      'proposalActive': '✅ सक्रिय',
      'proposalRejected': '❌ अस्वीकृत',
      'proposalPending': '⏳ pending',
      'proposalGpsVerified': '📍 GPS verified',
      'proposalVouching': '🤝 vouching',
      'proposalVoting': '🗳️ voting',
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
      // Challenge days
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
      // Universal Proposal
      'universalProposal': '🌍 Universal Proposal',
      'newProposal': 'Submit New Proposal',
      'proposalName': 'Circle Name *',
      'proposalDescription': 'Description',
      'proposalLatitude': 'Latitude *',
      'proposalLongitude': 'Longitude *',
      'gpsVerify': '📍 Verify GPS',
      'gpsVerified': '✅ GPS Verified',
      'gpsVerifyAgain': 'Verify Again',
      'gpsRequired': '📍 Go to this location and verify',
      'submitProposal': '📤 Submit Proposal',
      'proposalSubmitted': '✅ Proposal Submitted!',
      'proposalNameRequired': '❌ Please enter a name',
      'gpsFirst': '❌ Please verify GPS first',
      'noProposals': 'No proposals',
      'beFirst': 'Be the first to submit a Universal Circle proposal!',
      'proposalStatus': '📌 Status:',
      'proposalVotes': 'votes',
      'proposalSupport': 'Support',
      'proposalOppose': 'Oppose',
      'loginToVote': '🔑 Login to vote',
      'alreadyVoted': '❌ You have already voted!',
      'voteSupport': '✅ You supported!',
      'voteOppose': '❌ You opposed!',
      'loginRequired': '🔑 Please login',
      'proposalActive': '✅ Active',
      'proposalRejected': '❌ Rejected',
      'proposalPending': '⏳ pending',
      'proposalGpsVerified': '📍 GPS verified',
      'proposalVouching': '🤝 vouching',
      'proposalVoting': '🗳️ voting',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key]!;
  }

  // ===== UI Getters =====
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

  // ===== Challenge Days =====
  String challengeDay(int day) => translate('challenge_day_$day');

  // ===== Universal Proposal =====
  String get universalProposal => translate('universalProposal');
  String get newProposal => translate('newProposal');
  String get proposalName => translate('proposalName');
  String get proposalDescription => translate('proposalDescription');
  String get proposalLatitude => translate('proposalLatitude');
  String get proposalLongitude => translate('proposalLongitude');
  String get gpsVerify => translate('gpsVerify');
  String get gpsVerified => translate('gpsVerified');
  String get gpsVerifyAgain => translate('gpsVerifyAgain');
  String get gpsRequired => translate('gpsRequired');
  String get submitProposal => translate('submitProposal');
  String get proposalSubmitted => translate('proposalSubmitted');
  String get proposalNameRequired => translate('proposalNameRequired');
  String get gpsFirst => translate('gpsFirst');
  String get noProposals => translate('noProposals');
  String get beFirst => translate('beFirst');
  String get proposalStatus => translate('proposalStatus');
  String get proposalVotes => translate('proposalVotes');
  String get proposalSupport => translate('proposalSupport');
  String get proposalOppose => translate('proposalOppose');
  String get loginToVote => translate('loginToVote');
  String get alreadyVoted => translate('alreadyVoted');
  String get voteSupport => translate('voteSupport');
  String get voteOppose => translate('voteOppose');
  String get loginRequired => translate('loginRequired');
  String get proposalActive => translate('proposalActive');
  String get proposalRejected => translate('proposalRejected');
  String get proposalPending => translate('proposalPending');
  String get proposalGpsVerified => translate('proposalGpsVerified');
  String get proposalVouching => translate('proposalVouching');
  String get proposalVoting => translate('proposalVoting');
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
