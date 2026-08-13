import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

class CircleGuide {
  final String type;
  final String title;
  final String description;
  final String requirements;
  final String benefits;
  final Color color;

  CircleGuide({
    required this.type,
    required this.title,
    required this.description,
    required this.requirements,
    required this.benefits,
    required this.color,
  });
}

class CircleGuideData {
  static List<CircleGuide> getGuides(BuildContext context) {
    final local = AppLocalizations.of(context);

    return [
      CircleGuide(
        type: 'family',
        title: local.familyCircleTitle ?? '🏠 পারিবারিক সার্কেল',
        description: local.familyCircleDesc ?? 'পরিবার ও আত্মীয়দের জন্য একটি প্রাইভেট সার্কেল।',
        requirements: local.familyCircleReq ?? '✅ শুধু ইনভাইটের মাধ্যমে যোগ দিন।\n✅ সর্বনিম্ন ২ জন সদস্য।\n✅ জিপিএস ভেরিফিকেশন প্রয়োজন নেই।',
        benefits: local.familyCircleBen ?? '🌟 পরিবারের সাথে নিয়মিত চর্চা করুন।\n🌟 স্ট্রিক ও এক্সপি সংগ্রহ করুন।\n🌟 নিরাপদ ও ব্যক্তিগত পরিবেশ।',
        color: Colors.green,
      ),
      CircleGuide(
        type: 'social',
        title: local.socialCircleTitle ?? '🤝 সামাজিক সার্কেল',
        description: local.socialCircleDesc ?? 'বন্ধু, প্রতিবেশী বা সহকর্মীদের জন্য একটি খোলা সার্কেল।',
        requirements: local.socialCircleReq ?? '✅ জিপিএস ভেরিফিকেশন প্রয়োজন।\n✅ সর্বনিম্ন ৩ জন সদস্য।\n✅ অ্যাডমিন অনুমোদন প্রয়োজন।',
        benefits: local.socialCircleBen ?? '🌟 নতুন মানুষদের সাথে পরিচিত হন।\n🌟 গ্রুপ অ্যাক্টিভিটি করুন।\n🌟 কমিউনিটি তৈরি করুন।',
        color: Colors.blue,
      ),
      CircleGuide(
        type: 'universal',
        title: local.universalCircleTitle ?? '🌍 সার্বিক সার্কেল',
        description: local.universalCircleDesc ?? 'সবার জন্য উন্মুক্ত একটি পাবলিক সার্কেল।',
        requirements: local.universalCircleReq ?? '✅ জিপিএস ভেরিফিকেশন আবশ্যক।\n✅ ২টি সামাজিক সার্কেলের অনুমোদন প্রয়োজন।\n✅ সর্বনিম্ন ৫ জন সদস্য।\n✅ ৬টি ভোট প্রয়োজন।',
        benefits: local.universalCircleBen ?? '🌟 বড় কমিউনিটির সাথে সংযুক্ত হন।\n🌟 ইভেন্ট ও মিটআপ আয়োজন করুন।\n🌟 লিডারশিপের সুযোগ।',
        color: Colors.deepOrange,
      ),
    ];
  }
}
