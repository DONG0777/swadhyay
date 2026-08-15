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
      // ===== Existing Keys (keep all) =====
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

      // ===== Universal Proposal System (Bengali) =====
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
      // ===== Universal Proposal System (Hindi) =====
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
      // ===== Universal Proposal System (English) =====
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

  // ===== UI Getters (existing) =====
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

  // ===== Universal Proposal System Getters =====
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
