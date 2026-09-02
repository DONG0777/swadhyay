import 'package:flutter/material.dart';

class AppStrings {
  static AppStrings of(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return AppStrings._(languageCode);
  }

  final String languageCode;

  AppStrings._(this.languageCode);

  String get myProfile => switch (languageCode) {
        'hi' => 'मेरी प्रोफ़ाइल',
        'en' => 'My Profile',
        _ => 'আমার প্রোফাইল',
      };

  String get name => switch (languageCode) {
        'hi' => 'नाम',
        'en' => 'Name',
        _ => 'নাম',
      };

  String get phone => switch (languageCode) {
        'hi' => 'फ़ोन',
        'en' => 'Phone',
        _ => 'ফোন',
      };

  String get city => switch (languageCode) {
        'hi' => 'शहर',
        'en' => 'City',
        _ => 'শহর',
      };

  String get area => switch (languageCode) {
        'hi' => 'क्षेत्र',
        'en' => 'Area',
        _ => 'এলাকা',
      };

  String get appLanguage => switch (languageCode) {
        'hi' => 'ऐप भाषा',
        'en' => 'App Language',
        _ => 'অ্যাপের ভাষা',
      };

  String get saveProfile => switch (languageCode) {
        'hi' => 'प्रोफ़ाइल सहेजें',
        'en' => 'Save Profile',
        _ => 'প্রোফাইল সংরক্ষণ করুন',
      };

  String get profileCouldNotBeLoaded => switch (languageCode) {
        'hi' => 'प्रोफ़ाइल लोड नहीं हो सकी।',
        'en' => 'Profile could not be loaded.',
        _ => 'প্রোফাইল লোড করা যায়নি।',
      };

  String get profileSavedSuccessfully => switch (languageCode) {
        'hi' => 'प्रोफ़ाइल सफलतापूर्वक सहेजी गई।',
        'en' => 'Profile saved successfully.',
        _ => 'প্রোফাইল সফলভাবে সংরক্ষিত হয়েছে।',
      };

  String get profileCouldNotBeSaved => switch (languageCode) {
        'hi' => 'प्रोफ़াইল सहेजी नहीं जा सकी।',
        'en' => 'Profile could not be saved.',
        _ => 'প্রোফাইল সংরক্ষণ করা যায়নি।',
      };

  String get welcome => switch (languageCode) {
        'hi' => 'स्वागत है',
        'en' => 'Welcome',
        _ => 'স্বাগতম',
      };

  String get userFallback => switch (languageCode) {
        'hi' => 'उपयोगकर्ता',
        'en' => 'User',
        _ => 'ব্যবহারকারী',
      };

  String get adminDashboard => switch (languageCode) {
        'hi' => 'एडमिन डैशबोर्ड',
        'en' => 'Admin Dashboard',
        _ => 'অ্যাডমিন ড্যাশবোর্ড',
      };

  String get signOut => switch (languageCode) {
        'hi' => 'साइन आउट',
        'en' => 'Sign out',
        _ => 'সাইন আউট',
      };

  String get suryaNamaskar => switch (languageCode) {
        'hi' => 'सूर्य नमस्कार',
        'en' => 'Surya Namaskar',
        _ => 'সূর্য নমস্কার',
      };

  String get suryaNamaskarSubtitle => switch (languageCode) {
        'hi' => 'सूर्य नमस्कार के 12 चरण सीखें',
        'en' => 'Learn the 12 steps of Surya Namaskar',
        _ => 'সূর্য নমস্কারের ১২টি ধাপ শিখুন',
      };

  String get learning => switch (languageCode) {
        'hi' => 'सीखना',
        'en' => 'Learning',
        _ => 'শেখা',
      };

  String get learningSubtitle => switch (languageCode) {
        'hi' => 'ज्ञान और अभ्यासের মাধ্যমে এগিয়ে চলুন',
        'en' => 'Grow through knowledge and practice',
        _ => 'জ্ঞান ও অনুশীলনের মাধ্যমে এগিয়ে চলুন',
      };

  String get startMySwadhyay => switch (languageCode) {
        'hi' => 'अपना स्वाध्याय शुरू करें',
        'en' => 'Start My Swadhyay',
        _ => 'আমার স্বাধ্যায় শুরু করি',
      };

  String get startMySwadhyaySubtitle => switch (languageCode) {
        'hi' => 'आज से अपनी व्यक्तिगत साधना की यात्रा शुरू करें',
        'en' => 'Begin your personal practice journey',
        _ => 'আজ থেকেই আপনার ব্যক্তিগত সাধনার যাত্রা শুরু করুন',
      };

  String get todaysCommitment => switch (languageCode) {
        'hi' => 'आज का संकल्प',
        'en' => 'Today’s Commitment',
        _ => 'আজকের সংকল্প',
      };

  String get todaysCommitmentSubtitle => switch (languageCode) {
        'hi' => 'आज क्या अभ्यास करेंगे, तय करें',
        'en' => 'Decide what you will practice today',
        _ => 'আজ কী অনুশীলন করবেন, ঠিক করুন',
      };

  String get nightReflection => switch (languageCode) {
        'hi' => 'रात्रि आत्म-चिंतन',
        'en' => 'Night Reflection',
        _ => 'রাতের আত্ম-বিশ্লেষণ',
      };

  String get nightReflectionSubtitle => switch (languageCode) {
        'hi' => 'দিনের শেষে নিজের দিকে ফিরে देखें',
        'en' => 'Reflect on yourself at the end of the day',
        _ => 'দিনের শেষে নিজের দিকে ফিরে দেখুন',
      };

  String get myCommunity => switch (languageCode) {
        'hi' => 'मेरा समुदाय',
        'en' => 'My Community',
        _ => 'আমার কমিউনিটি',
      };

  String get myCommunitySubtitle => switch (languageCode) {
        'hi' => 'अपने आसपास के साधकों से जुड़ें',
        'en' => 'Connect with practitioners around you',
        _ => 'আপনার আশেপাশের সাধকদের সঙ্গে যুক্ত হন',
      };

  String get community => switch (languageCode) {
        'hi' => 'समुदाय',
        'en' => 'Community',
        _ => 'কমিউনিটি',
      };

  String get communitySubtitle => switch (languageCode) {
        'hi' => 'साथ मिलकर अभ्यास और विकास',
        'en' => 'Practice and grow together',
        _ => 'একসঙ্গে অনুশীলন ও বিকাশ',
      };

  String get communitySuryaNamaskar => switch (languageCode) {
        'hi' => 'सामूहिक सूर्य नमस्कार',
        'en' => 'Community Surya Namaskar',
        _ => 'সম্মিলিত সূর্য নমস্কার',
      };

  String get communitySuryaNamaskarSubtitle => switch (languageCode) {
        'hi' => 'साथ मिलकर सूर्य नमस्कार का अभ्यास करें',
        'en' => 'Practice Surya Namaskar together',
        _ => 'একসঙ্গে সূর্য নমস্কারের অনুশীলন করুন',
      };

  String get growthInsight => switch (languageCode) {
        'hi' => 'ग्रोथ इनसाइट',
        'en' => 'Growth Insight',
        _ => 'গ্রোথ ইনসাইট',
      };

  String get growthInsightSubtitle => switch (languageCode) {
        'hi' => 'अपनी अभ्यास यात्रा को समझें',
        'en' => 'Understand your practice journey',
        _ => 'আপনার অনুশীলনের যাত্রাকে বুঝুন',
      };

  String get myJourney => switch (languageCode) {
        'hi' => 'मेरी यात्रा',
        'en' => 'My Journey',
        _ => 'আমার যাত্রা',
      };

  String get myJourneySubtitle => switch (languageCode) {
        'hi' => 'अपनी अब तक की यात्रा देखें',
        'en' => 'See your journey so far',
        _ => 'এখন পর্যন্ত আপনার যাত্রা দেখুন',
      };

  String get myContext => switch (languageCode) {
        'hi' => 'मेरी स्थिति',
        'en' => 'My Context',
        _ => 'আমার অবস্থান',
      };

  String get whereAreYouNow => switch (languageCode) {
        'hi' => 'आप अभी कहाँ हैं?',
        'en' => 'Where are you now?',
        _ => 'তুমি এখন কোথায় আছ?',
      };

  String get describeCurrentLife => switch (languageCode) {
        'hi' => 'अपने वर्तमान जीवन और आवश्यकताओं को अपने शब्दों में बताएं।',
        'en' => 'Describe your current life and needs in your own words.',
        _ => 'তোমার বর্তমান জীবন ও প্রয়োজনকে নিজের ভাষায় বোঝাও।',
      };

  String get currentSituation => switch (languageCode) {
        'hi' => 'वर्तमान में आपके जीवन में क्या चल रहा है?',
        'en' => 'What is happening in your life right now?',
        _ => 'বর্তমানে তোমার জীবনে কী চলছে?',
      };

  String get writeInYourOwnWords => switch (languageCode) {
        'hi' => 'अपने शब्दों में लिखें...',
        'en' => 'Write in your own words...',
        _ => 'নিজের ভাষায় লিখো...',
      };

  String get biggestNeed => switch (languageCode) {
        'hi' => 'आपके जीवन की सबसे बड़ी आवश्यकता क्या है?',
        'en' => 'What is your biggest need in life?',
        _ => 'তোমার জীবনের সবচেয়ে বড় প্রয়োজন কী?',
      };

  String get biggestNeedHint => switch (languageCode) {
        'hi' => 'जैसे: नियमित होना चाहता हूँ, मन को स्थिर करना चाहता हूँ...',
        'en' => 'E.g. I want to be consistent, I want to calm my mind...',
        _ => 'যেমন: নিয়মিত হতে চাই, মনকে স্থির রাখতে চাই...',
      };

  String get availableTimePerDay => switch (languageCode) {
        'hi' => 'आप प्रतिदिन कितने मिनट दे सकते हैं?',
        'en' => 'How many minutes can you give each day?',
        _ => 'প্রতিদিন কত মিনিট দিতে পারবে?',
      };

  String get minutesExample => switch (languageCode) {
        'hi' => 'जैसे: 20',
        'en' => 'E.g. 20',
        _ => 'যেমন: 20',
      };

  String get minutes => switch (languageCode) {
        'hi' => 'मिनट',
        'en' => 'minutes',
        _ => 'মিনিট',
      };

  String get save => switch (languageCode) {
        'hi' => 'सहेजें',
        'en' => 'Save',
        _ => 'সংরক্ষণ করুন',
      };

  String get saveChanges => switch (languageCode) {
        'hi' => 'परिवर्तन सहेजें',
        'en' => 'Save Changes',
        _ => 'পরিবর্তন সংরক্ষণ করুন',
      };

  String get timeValidationError => switch (languageCode) {
        'hi' => 'समय 0 से 1440 मिनट के बीच दें।',
        'en' => 'Please enter a time between 0 and 1440 minutes.',
        _ => 'সময় ০ থেকে ১৪৪০ মিনিটের মধ্যে দিন।',
      };

  String get contextSavedSuccessfully => switch (languageCode) {
        'hi' => 'आपकी जानकारी सफलतापूर्वक सहेजी गई।',
        'en' => 'Your information was saved successfully.',
        _ => 'আপনার তথ্য সংরক্ষিত হয়েছে।',
      };

  String contextLoadFailed(Object error) => switch (languageCode) {
        'hi' => 'स्थिति लोड नहीं हो सकी: $error',
        'en' => 'Context load failed: $error',
        _ => 'তথ্য লোড করা যায়নি: $error',
      };

  String contextSaveFailed(Object error) => switch (languageCode) {
        'hi' => 'जानकारी सहेजी नहीं जा सकी: $error',
        'en' => 'Save failed: $error',
        _ => 'তথ্য সংরক্ষণ করা যায়নি: $error',
      };
}
