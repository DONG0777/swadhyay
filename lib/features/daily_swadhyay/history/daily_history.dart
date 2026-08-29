import '../models/daily_commitment.dart';
import '../models/daily_reflection.dart';

class DailyHistoryItem {
  final DailyCommitment commitment;
  final DailyReflection? reflection;

  const DailyHistoryItem({
    required this.commitment,
    this.reflection,
  });

  bool get hasReflection => reflection != null;
}

class DailyHistorySummary {
  final int totalCommitments;
  final int completedCommitments;
  final int missedCommitments;
  final int totalReflections;

  const DailyHistorySummary({
    required this.totalCommitments,
    required this.completedCommitments,
    required this.missedCommitments,
    required this.totalReflections,
  });

  double get completionRate {
    if (totalCommitments == 0) {
      return 0;
    }

    return (completedCommitments / totalCommitments) * 100;
  }
}
