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
        'hi' => 'ज्ञान और अभ्यास के माध्यम से आगे बढ़ें',
        'en' => 'Grow through knowledge and practice',
        _ => 'জ্ঞান ও অনুশীলনের মাধ্যমে এগিয়ে চলুন',
      };

  String get learningSummary => switch (languageCode) {
        'hi' => 'सारांश',
        'en' => 'Summary',
        _ => 'সারাংশ',
      };

  String get learningMainContent => switch (languageCode) {
        'hi' => 'मूल लेख',
        'en' => 'Main Content',
        _ => 'মূল লেখা',
      };


  String get learningActionPrompt => switch (languageCode) {
        'hi' => 'आज का अभ्यास',
        'en' => 'Today''s Practice',
        _ => 'আজকের করণীয়',
      };

  String get retry => switch (languageCode) {
        'hi' => 'पुनः प्रयास करें',
        'en' => 'Retry',
        _ => 'আবার চেষ্টা করুন',
      };

  String get learningLoadFailed => switch (languageCode) {
        'hi' => 'सीखने की सामग्री लोड नहीं हो सकी।',
        'en' => 'Learning content could not be loaded.',
        _ => 'Learning content লোড করা যায়নি।',
      };

  String get learningTranslationNotFound => switch (languageCode) {
        'hi' => 'इस सीखने की सामग्री का अनुवाद उपलब्ध नहीं है।',
        'en' => 'Translation for this learning content is not available.',
        _ => 'এই Learning content-এর অনুবাদ পাওয়া যায়নি।',
      };

  String get learningMarkComplete => switch (languageCode) {
        'hi' => 'पूर्ण करें',
        'en' => 'Mark as complete',
        _ => 'সম্পন্ন করুন',
      };

  String get learningCompleted => switch (languageCode) {
        'hi' => 'पूर्ण हो गया',
        'en' => 'Completed',
        _ => 'সম্পন্ন হয়েছে',
      };

  String get learningCompletionFailed => switch (languageCode) {
        'hi' => 'सामग्री को पूर्ण के रूप में चिह्नित नहीं किया जा सका।',
        'en' => 'The learning content could not be marked as complete.',
        _ => 'Learning content সম্পন্ন হিসেবে চিহ্নিত করা যায়নি।',
      };

  String get learningProgress => switch (languageCode) {
        'hi' => 'मेरी प्रगति',
        'en' => 'My Progress',
        _ => 'আমার অগ্রগতি',
      };

  String get learningCompletedCount => switch (languageCode) {
        'hi' => 'पूर्ण',
        'en' => 'Completed',
        _ => 'সম্পন্ন',
      };

  String get learningNoProgress => switch (languageCode) {
        'hi' => 'अभी तक कोई सीख पूरी नहीं हुई है।',
        'en' => 'You have not completed any learning yet.',
        _ => 'এখনও কোনো শেখা সম্পন্ন হয়নি।',
      };

  String get learningProgressLoadFailed => switch (languageCode) {
        'hi' => 'प्रगति लोड नहीं की जा सकी।',
        'en' => 'Progress could not be loaded.',
        _ => 'অগ্রগতি লোড করা যায়নি।',
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

  static AppStrings forLanguage(String languageCode) {
    return AppStrings._(languageCode);
  }
  String get growthInsightNoDataHeadline {
    switch (languageCode) {
      case 'hi':
        return 'अभी पर्याप्त जानकारी नहीं है';
      case 'en':
        return 'Not Enough Data Yet';
      default:
        return 'এখনও যথেষ্ট তথ্য নেই';
    }
  }

  String get growthInsightNoDataDetail {
    switch (languageCode) {
      case 'hi':
        return 'कुछ दैनिक संकल्प पूरे या अधूरे के रूप में दर्ज होने के बाद आपकी अपनी यात्रा से समझ विकसित होगी।';
      case 'en':
        return 'Once a few daily commitments are recorded as completed or missed, insights will emerge from your own journey.';
      default:
        return 'কয়েকটি দৈনিক সংকল্প সম্পন্ন বা অসম্পন্ন হিসেবে নথিভুক্ত হলে তোমার নিজের যাত্রা থেকে একটি স্পষ্ট ধারণা তৈরি হবে।';
    }
  }

  String get growthInsightStartedHeadline {
    switch (languageCode) {
      case 'hi':
        return 'यात्रा शुरू हो गई है';
      case 'en':
        return 'Your Journey Has Started';
      default:
        return 'যাত্রা শুরু হয়েছে';
    }
  }

  String get growthInsightStartedDetail {
    switch (languageCode) {
      case 'hi':
        return 'अभी कोई स्पष्ट पैटर्न समझने के लिए पर्याप्त जानकारी नहीं है। कुछ और दिनों के संकल्प और आत्म-चिंतन दर्ज होने दें।';
      case 'en':
        return 'There is not enough data to identify a pattern yet. Let a few more days of commitments and reflections build up.';
      default:
        return 'এখনও কোনো স্পষ্ট ধারা বোঝার মতো যথেষ্ট তথ্য নেই। আরও কয়েকটি দিনের সংকল্প ও আত্ম-বিশ্লেষণ তৈরি হতে দাও।';
    }
  }

  String get growthInsightConsistencyHeadline {
    switch (languageCode) {
      case 'hi':
        return 'आपकी निरंतरता अच्छी है';
      case 'en':
        return 'Your Consistency Is Good';
      default:
        return 'তোমার ধারাবাহিকতা ভালো';
    }
  }

  String get growthInsightConsistencyDetail {
    switch (languageCode) {
      case 'hi':
        return 'संकल्पों को वास्तव में पूरा करने में आप अच्छी निरंतरता बना रहे हैं। अब संकल्पों को और अधिक स्पष्ट बनाया जा सकता है।';
      case 'en':
        return 'You are building good momentum in following through on your commitments. Now you can make your commitments more specific.';
      default:
        return 'সংকল্পগুলো বাস্তবে করার ক্ষেত্রে তুমি এখন ভালো ধারাবাহিকতা তৈরি করছ। এবার সংকল্পগুলো আরও নির্দিষ্ট করা যায়।';
    }
  }

  String get growthInsightFoundationHeadline {
    switch (languageCode) {
      case 'hi':
        return 'बुनियाद बन रही है';
      case 'en':
        return 'A Foundation Is Taking Shape';
      default:
        return 'ভিত্তি তৈরি হচ্ছে';
    }
  }

  String get growthInsightFoundationDetail {
    switch (languageCode) {
      case 'hi':
        return 'आपके कुछ संकल्प सफल हो रहे हैं। जो पूरे नहीं हुए, उनके कारण देखने से अगले कुछ दिनों में सुधार का स्पष्ट रास्ता मिल सकता है।';
      case 'en':
        return 'Some of your commitments are succeeding. Looking at why others were not completed can reveal a clear path for improvement over the next few days.';
      default:
        return 'তোমার কিছু সংকল্প সফল হচ্ছে। যেগুলো হয়নি, সেগুলোর কারণ দেখলে পরের কয়েক দিনে উন্নতির স্পষ্ট পথ পাওয়া যাবে।';
    }
  }

  String get growthInsightSmallerHeadline {
    switch (languageCode) {
      case 'hi':
        return 'संकल्प को और छोटा करें';
      case 'en':
        return 'Make Your Commitment Smaller';
      default:
        return 'সংকল্পকে আরও ছোট করো';
    }
  }

  String get growthInsightSmallerDetail {
    switch (languageCode) {
      case 'hi':
        return 'इन 7 दिनों में अधूरे संकल्प अधिक हैं। बड़े लक्ष्य लेने के बजाय छोटे और स्पष्ट काम से शुरुआत करना उपयोगी हो सकता है।';
      case 'en':
        return 'There have been more incomplete commitments in these 7 days. It may help to start with smaller, more specific actions instead of larger goals.';
      default:
        return 'এই ৭ দিনে অসম্পন্ন সংকল্প বেশি। বড় লক্ষ্য না নিয়ে আরও ছোট এবং নির্দিষ্ট কাজ দিয়ে শুরু করা উপকারী হতে পারে।';
    }
  }

  String get growthInsightReflectionHeadline {
    switch (languageCode) {
      case 'hi':
        return 'काम के साथ आत्म-चिंतन भी ज़रूरी है';
      case 'en':
        return 'Action Needs Reflection Too';
      default:
        return 'কাজের সঙ্গে আত্ম-বিশ্লেষণও দরকার';
    }
  }

  String get growthInsightReflectionDetail {
    switch (languageCode) {
      case 'hi':
        return 'सिर्फ संकल्प ही नहीं—दिन के अंत में कुछ मिनट अपने अनुभव लिखने से अपने व्यवहार की धारा समझना आसान होगा।';
      case 'en':
        return 'Commitments are not the whole picture—writing about your experience for a few minutes at the end of the day can make patterns easier to understand.';
      default:
        return 'শুধু সংকল্প নয়—দিন শেষে কয়েক মিনিট নিজের অভিজ্ঞতা লিখলে নিজের আচরণের ধারা বোঝা সহজ হবে।';
    }
  }

  String get growthInsightMindfulHeadline {
    switch (languageCode) {
      case 'hi':
        return 'धीरे, लेकिन सजग होकर आगे बढ़ें';
      case 'en':
        return 'Move Slowly, But Mindfully';
      default:
        return 'ধীরে, কিন্তু সচেতনভাবে এগোও';
    }
  }

  String get growthInsightMindfulDetail {
    switch (languageCode) {
      case 'hi':
        return 'संकल्प, कार्य और आत्म-चिंतन—इन तीनों को नियमित रखना अभी सबसे महत्वपूर्ण है।';
      case 'en':
        return 'For now, the most important thing is to keep commitment, action, and reflection consistent.';
      default:
        return 'সংকল্প, কাজ এবং আত্ম-বিশ্লেষণ—এই তিনটিকে নিয়মিত রাখাই এখন সবচেয়ে গুরুত্বপূর্ণ।';
    }
  }
  String growthInsightLoadFailed(Object error) => switch (languageCode) {
        'hi' => 'Growth Insight लोड नहीं हो सका: $error',
        'en' => 'Growth Insight could not be loaded: $error',
        _ => 'Growth Insight লোড করা যায়নি: $error',
      };

  String get growthInsightNotFound => switch (languageCode) {
        'hi' => 'Insight उपलब्ध नहीं है।',
        'en' => 'No insight available.',
        _ => 'Insight পাওয়া যায়নি।',
      };

  String get sevenDayGrowthInsightTitle => switch (languageCode) {
        'hi' => '7 दिनों की प्रगति की झलक',
        'en' => '7-Day Growth Insight',
        _ => '৭ দিনের অগ্রগতির বিশ্লেষণ',
      };

  String get reflectionMetric => switch (languageCode) {
        'hi' => 'आत्म-चिंतन',
        'en' => 'Reflection',
        _ => 'আত্ম-বিশ্লেষণ',
      };

  String get reflectionCoverage => switch (languageCode) {
        'hi' => 'आत्म-चिंतन कवरेज',
        'en' => 'Reflection Coverage',
        _ => 'আত্ম-বিশ্লেষণের হার',
      };

  String get reflectionCoverageDescription => switch (languageCode) {
        'hi' => 'जिन दिनों संकल्प था, उनमें कितने दिनों आत्म-चिंतन हुआ',
        'en' => 'How many days had a reflection among the days when you had a commitment',
        _ => 'যে দিন সংকল্প ছিল, তার মধ্যে কত দিনে আত্ম-বিশ্লেষণ হয়েছে',
      };

  String get insightPersonalDataDescription => switch (languageCode) {
        'hi' => 'यह insight आपके अपने data से तैयार हुआ है।',
        'en' => 'This insight is generated from your own data.',
        _ => 'এই insight তোমার নিজের data থেকে তৈরি।',
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

  String get learningKindKnowledge => switch (languageCode) {
        'hi' => 'ज्ञान',
        'en' => 'Knowledge',
        _ => 'জ্ঞান',
      };

  String get learningKindQuote => switch (languageCode) {
        'hi' => 'उद्धरण',
        'en' => 'Quote',
        _ => 'উক্তি',
      };

  String get learningKindStory => switch (languageCode) {
        'hi' => 'कहानी',
        'en' => 'Story',
        _ => 'গল্প',
      };

  String get learningKindSong => switch (languageCode) {
        'hi' => 'गीत',
        'en' => 'Song',
        _ => 'গান',
      };

  String get learningKindReflection => switch (languageCode) {
        'hi' => 'आत्म-चिंतन',
        'en' => 'Reflection',
        _ => 'আত্মচিন্তন',
      };

  String get learningKindCivicThought => switch (languageCode) {
        'hi' => 'नागरिक विचार',
        'en' => 'Civic Thought',
        _ => 'নাগরিক ভাবনা',
      };

  String get learningKindSevaIdea => switch (languageCode) {
        'hi' => 'सेवा विचार',
        'en' => 'Seva Idea',
        _ => 'সেবা ভাবনা',
      };

  String get learningKindQuiz => switch (languageCode) {
        'hi' => 'प्रश्नोत्तरी',
        'en' => 'Quiz',
        _ => 'কুইজ',
      };

  String get learningDifficulty => switch (languageCode) {
        'hi' => 'कठिनाई',
        'en' => 'Difficulty',
        _ => 'কঠিনতার মাত্রা',
      };

  String get learningDifficultyEasy => switch (languageCode) {
    'hi' => 'आसान',
    'en' => 'Easy',
    _ => 'সহজ',
  };

  String get learningDifficultyMedium => switch (languageCode) {
    'hi' => 'मध्यम',
    'en' => 'Medium',
    _ => 'মাঝারি',
  };

  String get learningDifficultyHard => switch (languageCode) {
    'hi' => 'कठिन',
    'en' => 'Hard',
    _ => 'কঠিন',
  };
  String get learningNoContent => switch (languageCode) {
        'hi' => 'अभी कोई सीखने की सामग्री उपलब्ध नहीं है।',
        'en' => 'No learning content available yet.',
        _ => 'এখনও কোনো শেখার কনটেন্ট পাওয়া যায়নি।',
      };

  String get dailySwadhyay => switch (languageCode) {
        'hi' => 'आज का स्वाध्याय',
        'en' => 'Today''s Swadhyay',
        _ => 'আজকের স্বাধ্যায়',
      };

  String get dailyCommitmentPrompt => switch (languageCode) {
        'hi' => 'आज का एक छोटा संकल्प',
        'en' => 'One Small Commitment for Today',
        _ => 'আজকের একটি ছোট সংকল্প',
      };

  String get dailyCommitmentPromptDescription => switch (languageCode) {
        'hi' => 'ऐसा एक काम चुनें, जिसे आज वास्तव में किया जा सके।',
        'en' => 'Choose one action that you can realistically do today.',
        _ => 'এমন একটি কাজ বেছে নিন, যা আজ বাস্তবে করা সম্ভব।',
      };

  String get myTodaysCommitment => switch (languageCode) {
        'hi' => 'मेरा आज का संकल्प',
        'en' => 'My Commitment for Today',
        _ => 'আমার আজকের সংকল্প',
      };

  String get dailyCommitmentHint => switch (languageCode) {
        'hi' => 'जैसे: गुस्से के समय जवाब देने से पहले 10 सेकंड रुकूँगा।',
        'en' => 'E.g. I will pause for 10 seconds before responding when I feel angry.',
        _ => 'যেমন: রাগের মুহূর্তে উত্তর দেওয়ার আগে ১০ সেকেন্ড থামব।',
      };

  String get dailyCommitmentValidation => switch (languageCode) {
        'hi' => 'एक छोटा और स्पष्ट संकल्प लिखें।',
        'en' => 'Please write a small and specific commitment.',
        _ => 'একটি ছোট ও নির্দিষ্ট সংকল্প লিখুন।',
      };

  String get saveTodaysCommitment => switch (languageCode) {
        'hi' => 'आज का संकल्प सहेजें',
        'en' => 'Save Today''s Commitment',
        _ => 'আজকের সংকল্প সংরক্ষণ করুন',
      };

  String get dailyCommitmentSavedSuccessfully => switch (languageCode) {
        'hi' => 'आज का संकल्प सफलतापूर्वक सहेजा गया।',
        'en' => 'Today''s commitment has been saved.',
        _ => 'আজকের সংকল্প সংরক্ষিত হয়েছে।',
      };

  String dailyCommitmentLoadFailed(Object error) => switch (languageCode) {
        'hi' => 'आज का संकल्प लोड नहीं हो सका: $error',
        'en' => 'Today''s commitment could not be loaded: $error',
        _ => 'আজকের সংকল্প লোড করা যায়নি: $error',
      };

  String dailyCommitmentSaveFailed(Object error) => switch (languageCode) {
        'hi' => 'संकल्प सहेजा नहीं जा सका: $error',
        'en' => 'Commitment could not be saved: $error',
        _ => 'সংকল্প সংরক্ষণ করা যায়নি: $error',
      };

  String get dailyCommitmentCompletedSuccessfully => switch (languageCode) {
        'hi' => 'आज का संकल्प पूरा हो गया।',
        'en' => 'Today''s commitment has been completed.',
        _ => 'আজকের সংকল্প সম্পন্ন হয়েছে।',
      };

  String get dailyCommitmentMissedSuccessfully => switch (languageCode) {
        'hi' => 'आज का संकल्प पूरा नहीं हो पाया। अब कारण को समझने का समय है।',
        'en' => 'Today''s commitment was not completed. It is time to understand why.',
        _ => 'আজকের সংকল্প সম্পন্ন হয়নি। কারণটি বুঝে নেওয়ার সময় এসেছে।',
      };

  String dailyCommitmentStatusUpdateFailed(Object error) => switch (languageCode) {
        'hi' => 'संकल्प की स्थिति बदली नहीं जा सकी: $error',
        'en' => 'The commitment status could not be changed: $error',
        _ => 'সংকল্পের অবস্থা পরিবর্তন করা যায়নি: $error',
      };

  String get dailyCommitmentCompleted => switch (languageCode) {
        'hi' => 'आज का संकल्प पूरा हो गया है',
        'en' => 'Today''s commitment is completed',
        _ => 'আজকের সংকল্প সম্পন্ন হয়েছে',
      };

  String get goToTodaysReflection => switch (languageCode) {
        'hi' => 'आज के आत्म-चिंतन पर जाएँ',
        'en' => 'Go to Today''s Reflection',
        _ => 'আজকের আত্ম-বিশ্লেষণে যান',
      };

  String get dailyCommitmentMissed => switch (languageCode) {
        'hi' => 'आज का संकल्प पूरा नहीं हुआ',
        'en' => 'Today''s commitment was not completed',
        _ => 'আজকের সংকল্প সম্পন্ন হয়নি',
      };

  String get understandTodaysExperience => switch (languageCode) {
        'hi' => 'आज के अनुभव को समझें',
        'en' => 'Understand Today''s Experience',
        _ => 'আজকের অভিজ্ঞতা বুঝে নিই',
      };

  String get iCompletedIt => switch (languageCode) {
        'hi' => 'मैंने पूरा किया',
        'en' => 'I completed it',
        _ => 'আমি পালন করেছি',
      };

  String get iCouldNotCompleteIt => switch (languageCode) {
        'hi' => 'मैं पूरा नहीं कर पाया',
        'en' => 'I could not complete it',
        _ => 'আমি পালন করতে পারিনি',
      };

  String get dailyReflectionAppBar => switch (languageCode) {
        'hi' => 'रात का आत्म-चिंतन',
        'en' => 'Evening Reflection',
        _ => 'রাতের আত্ম-বিশ্লেষণ',
      };

  String get createTodaysCommitmentFirst => switch (languageCode) {
        'hi' => 'पहले आज का संकल्प बनाएं',
        'en' => 'Create Today''s Commitment First',
        _ => 'আজকের সংকল্প আগে তৈরি করুন',
      };

  String get commitmentNeededBeforeReflection => switch (languageCode) {
        'hi' => 'आज का आत्म-चिंतन शुरू करने से पहले आज का एक संकल्प होना आवश्यक है।',
        'en' => 'You need a commitment for today before starting today''s reflection.',
        _ => 'আজকের আত্ম-বিশ্লেষণ শুরু করার আগে আজকের একটি সংকল্প থাকা প্রয়োজন।',
      };

  String get todaysCommitmentLabel => switch (languageCode) {
        'hi' => 'आज का संकल्प',
        'en' => 'Today''s Commitment',
        _ => 'আজকের সংকল্প',
      };

  String get understandTodaysExperienceTitle => switch (languageCode) {
        'hi' => 'आज के अनुभव को समझें',
        'en' => 'Understand Today''s Experience',
        _ => 'আজকের অভিজ্ঞতাটা বুঝে নিই',
      };

  String get pauseForTodayTitle => switch (languageCode) {
        'hi' => 'आज थोड़ा रुकें',
        'en' => 'Pause for Today',
        _ => 'আজ একটু থামি',
      };

  String get reflectionPurposeDescription => switch (languageCode) {
        'hi' => 'खुद को दोष देने के लिए नहीं, बल्कि अपने पैटर्न को समझने के लिए लिखें।',
        'en' => 'Write not to blame yourself, but to understand your patterns.',
        _ => 'নিজেকে দোষ দেওয়ার জন্য নয়, নিজের প্যাটার্নকে বোঝার জন্য লিখুন।',
      };

  String get egoReflectionQuestion => switch (languageCode) {
        'hi' => 'आज कहाँ स्वार्थ या अहंकार ने मुझे प्रभावित किया?',
        'en' => 'Where did self-interest or ego influence me today?',
        _ => 'আজ কোথায় স্বার্থ বা অহংকার আমাকে পরিচালিত করেছে?',
      };

  String get reflectionWriteHint => switch (languageCode) {
        'hi' => 'अपनी भाषा में लिखें...',
        'en' => 'Write in your own words...',
        _ => 'নিজের ভাষায় লিখুন...',
      };

  String get idealGapReflectionQuestion => switch (languageCode) {
        'hi' => 'आज कौन-सा काम या बात मेरे आदर्श के अनुरूप नहीं था?',
        'en' => 'What action or word today did not align with my ideals?',
        _ => 'আজ কোন কাজ বা কথা আমার আদর্শের সঙ্গে মেলেনি?',
      };


  String get commitmentNotCompletedDescription => switch (languageCode) {
        'hi' => 'आज का संकल्प पूरा नहीं हुआ। पहले कारण को समझना आवश्यक है।',
        'en' => 'Today''s commitment was not completed. First, it is important to understand why.',
        _ => 'সংকল্পটি আজ পূরণ হয়নি। আগে কারণটি বুঝে নেওয়া দরকার।',
      };

  String get obstacleReflectionQuestion => switch (languageCode) {
        'hi' => 'आज कौन-सी बाधा आपको रोक रही थी?',
        'en' => 'What obstacle held you back today?',
        _ => 'কোন বাধাটা তোমাকে আজ আটকে দিয়েছিল?',
      };

  String get obstacleReflectionHint => switch (languageCode) {
        'hi' => 'समय, वातावरण, आदत या कोई अन्य वास्तविक कारण...',
        'en' => 'Time, environment, habit, or another practical reason...',
        _ => 'সময়, পরিবেশ, অভ্যাস বা অন্য কোনো বাস্তব কারণ...',
      };

  String get saveReflection => switch (languageCode) {
        'hi' => 'आत्म-चिंतन सहेजें',
        'en' => 'Save Reflection',
        _ => 'আত্ম-বিশ্লেষণ সংরক্ষণ করুন',
      };


  String get reflectionSavedSuccessfully => switch (languageCode) {
        'hi' => 'आज का आत्म-चिंतन सहेजा गया है।',
        'en' => 'Today''s reflection has been saved.',
        _ => 'আজকের আত্ম-বিশ্লেষণ সংরক্ষিত হয়েছে।',
      };

  String reflectionLoadFailed(Object error) => switch (languageCode) {
        'hi' => 'आज का स्वाध्याय लोड नहीं हो सका: $error',
        'en' => 'Today''s Swadhyay could not be loaded: $error',
        _ => 'আজকের স্বাধ্যায় লোড করা যায়নি: $error',
      };


  String get incompleteCommitmentObstacleRequired => switch (languageCode) {
        'hi' => 'संकल्प पूरा नहीं हुआ है, इसलिए बाधा का कारण लिखना आवश्यक है।',
        'en' => 'Please write the reason for the obstacle when the commitment was not completed.',
        _ => 'সংকল্প পূরণ না হলে বাধার কারণ লেখা বাধ্যতামূলক।',
      };

  String get missedCommitmentObstacleRequired => switch (languageCode) {
        'hi' => 'संकल्प पूरा नहीं हुआ। पहले बताएं कि किस बाधा ने आपको रोका।',
        'en' => 'The commitment was not completed. First, write what obstacle held you back.',
        _ => 'সংকল্পটি পূরণ হয়নি। আগে কী বাধা দিয়েছিল সেটি লিখুন।',
      };

  String get goToTomorrowCommitment => switch (languageCode) {
        'hi' => 'कल का संकल्प लें',
        'en' => 'Set Tomorrow''s Commitment',
        _ => 'আগামীকালের সংকল্প নিন',
      };

  String reflectionSaveFailed(Object error) => switch (languageCode) {
        'hi' => 'आत्म-चिंतन सहेजा नहीं जा सका: $error',
        'en' => 'Reflection could not be saved: $error',
        _ => 'আত্ম-বিশ্লেষণ সংরক্ষণ করা যায়নি: $error',
      };


  String tomorrowCommitmentLoadFailed(Object error) => switch (languageCode) {
    'hi' => 'कल का संकल्प लोड नहीं हो सका: $error',
    'en' => 'Tomorrow''s commitment could not be loaded: $error',
    _ => 'আগামীকালের সংকল্প লোড করা যায়নি: $error',
  };

  String get tomorrowCommitmentInstruction => switch (languageCode) {
    'hi' => 'कल के लिए एक छोटा और स्पष्ट संकल्प लिखें।',
    'en' => 'Write a small and specific commitment for tomorrow.',
    _ => 'আগামীকালের জন্য একটি ছোট ও নির্দিষ্ট সংকল্প লিখুন।',
  };

  String get tomorrowCommitmentSavedSuccessfully => switch (languageCode) {
    'hi' => 'कल का संकल्प सफलतापूर्वक सहेजा गया।',
    'en' => 'Tomorrow''s commitment has been saved successfully.',
    _ => 'আগামীকালের সংকল্প সংরক্ষিত হয়েছে।',
  };

  String tomorrowCommitmentSaveFailed(Object error) => switch (languageCode) {
    'hi' => 'कल का संकल्प सहेजा नहीं जा सका: $error',
    'en' => 'Tomorrow''s commitment could not be saved: $error',
    _ => 'আগামীকালের সংকল্প সংরক্ষণ করা যায়নি: $error',
  };

  String get tomorrowCommitmentTitle => switch (languageCode) {
    'hi' => 'कल का संकल्प',
    'en' => 'Tomorrow''s Commitment',
    _ => 'আগামীকালের সংকল্প',
  };

  String get tomorrowCommitmentQuestion => switch (languageCode) {
    'hi' => 'कल थोड़ा बेहतर कैसे करूँ?',
    'en' => 'How can I do a little better tomorrow?',
    _ => 'আগামীকাল একটু ভালো কীভাবে করব?',
  };

  String tomorrowCommitmentDate(String tomorrowLabel) => switch (languageCode) {
    'hi' => 'तारीख: $tomorrowLabel',
    'en' => 'Date: $tomorrowLabel',
    _ => 'তারিখ: $tomorrowLabel',
  };

  String get tomorrowCommitmentDescription => switch (languageCode) {
    'hi' => 'आज जो सीखा, उसके आधार पर कल के लिए एक छोटा, स्पष्ट और वास्तव में किया जा सकने वाला काम चुनें।',
    'en' => 'Based on what you learned today, choose a small, specific, and realistic action for tomorrow.',
    _ => 'আজ যা শিখলে, তার ভিত্তিতে আগামীকালের জন্য একটি ছোট, নির্দিষ্ট এবং বাস্তবে করা সম্ভব এমন কাজ বেছে নিন।',
  };

  String get tomorrowCommitmentLabel => switch (languageCode) {
    'hi' => 'मेरा कल का संकल्प',
    'en' => 'My Commitment for Tomorrow',
    _ => 'আমার আগামীকালের সংকল্প',
  };

  String get tomorrowCommitmentExample => switch (languageCode) {
    'hi' => 'जैसे: सुबह 10 मिनट ध्यानपूर्वक स्वाध्याय करूँगा।',
    'en' => 'Example: I will spend 10 minutes on focused Swadhyay in the morning.',
    _ => 'যেমন: সকালে ১০ মিনিট মনোযোগ দিয়ে স্বাধ্যায় করব।',
  };

  String get tomorrowCommitmentSave => switch (languageCode) {
    'hi' => 'कल का संकल्प सहेजें',
    'en' => 'Save Tomorrow''s Commitment',
    _ => 'আগামীকালের সংকল্প সংরক্ষণ করুন',
  };
  String get learningReflectionQuestion {
    switch (languageCode) {
      case 'hi':
        return 'आज मैंने क्या सीखा और कल कौन-सी गलती दोबारा नहीं करूँगा?';
      case 'en':
        return 'What did I learn today, and what mistake will I avoid tomorrow?';
      default:
        return 'আজ আমি কী শিখলাম এবং আগামীকাল কোন ভুলটি আর করব না?';
    }
  }

  String get saveChanges {
    switch (languageCode) {
      case 'hi':
        return 'परिवर्तन सहेजें';
      case 'en':
        return 'Save Changes';
      default:
        return 'পরিবর্তন সংরক্ষণ করুন';
    }
  }
  String get dailyCommitmentInProgress => switch (languageCode) {
    'hi' => 'प्रगति पर है',
    'en' => 'In Progress',
    _ => 'চলমান',
  };
  String dailyHistoryLoadFailed(Object error) => switch (languageCode) {
    'hi' => 'इतिहास लोड नहीं हो सका: $error',
    'en' => 'History could not be loaded: $error',
    _ => 'ইতিহাস লোড করা যায়নি: $error',
  };

  String get myLast30Days => switch (languageCode) {
    'hi' => 'मेरे पिछले 30 दिन',
    'en' => 'My Last 30 Days',
    _ => 'আমার গত ৩০ দিন',
  };

  String get journeyDescription => switch (languageCode) {
    'hi' => 'अपनी यात्रा को देखें—तुलना करने के लिए नहीं, बल्कि समझने के लिए।',
    'en' => 'Look at your journey—not to compare, but to understand yourself.',
    _ => 'নিজের যাত্রাকে দেখুন—তুলনা করার জন্য নয়, বুঝে ওঠার জন্য।',
  };

  String get totalCommitments => switch (languageCode) {
    'hi' => 'कुल संकल्प',
    'en' => 'Total Commitments',
    _ => 'মোট সংকল্প',
  };

  String get completed => switch (languageCode) {
    'hi' => 'पूरा हुआ',
    'en' => 'Completed',
    _ => 'সম্পন্ন',
  };

  String get missed => switch (languageCode) {
    'hi' => 'अधूरा',
    'en' => 'Not Completed',
    _ => 'অসম্পন্ন',
  };

  String get reflections => switch (languageCode) {
    'hi' => 'आत्म-चिंतन',
    'en' => 'Reflections',
    _ => 'আত্ম-বিশ্লেষণ',
  };

  String get successRate => switch (languageCode) {
    'hi' => 'सफलता दर',
    'en' => 'Success Rate',
    _ => 'সফলতার হার',
  };

  String get dayByDayJourney => switch (languageCode) {
    'hi' => 'दिन-प्रतिदिन की यात्रा',
    'en' => 'Day-by-Day Journey',
    _ => 'দিনভিত্তিক যাত্রা',
  };

  String get noDailyCommitmentHistory => switch (languageCode) {
    'hi' => 'अभी तक किसी दैनिक संकल्प का इतिहास नहीं बना है।',
    'en' => 'No daily commitment history has been created yet.',
    _ => 'এখনও কোনো দৈনিক সংকল্পের ইতিহাস তৈরি হয়নি।',
  };

  String get reflectionAvailable => switch (languageCode) {
    'hi' => 'आत्म-चिंतन उपलब्ध है',
    'en' => 'Reflection available',
    _ => 'আত্ম-বিশ্লেষণ আছে',
  };

  List<String> get monthNames => switch (languageCode) {
    'hi' => [
      'जनवरी',
      'फ़रवरी',
      'मार्च',
      'अप्रैल',
      'मई',
      'जून',
      'जुलाई',
      'अगस्त',
      'सितंबर',
      'अक्टूबर',
      'नवंबर',
      'दिसंबर',
    ],
    'en' => [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
    _ => [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর',
    ],
  };
  String get commitmentCompletedLabel => switch (languageCode) {
    'hi' => 'मैंने पूरा किया',
    'en' => 'I completed it',
    _ => 'আমি পালন করেছি',
  };

  String get commitmentNotCompletedLabel => switch (languageCode) {
    'hi' => 'मैं पूरा नहीं कर पाया',
    'en' => 'I could not complete it',
    _ => 'আমি পালন করতে পারিনি',
  };

  String get dailyCommitmentExample => switch (languageCode) {
    'hi' => 'जैसे: गुस्से के क्षण में जवाब देने से पहले 10 सेकंड रुकूँगा।',
    'en' => 'Example: I will pause for 10 seconds before responding in a moment of anger.',
    _ => 'যেমন: রাগের মুহূর্তে উত্তর দেওয়ার আগে ১০ সেকেন্ড থামব।',
  };

}
