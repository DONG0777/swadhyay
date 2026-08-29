class GrowthInsight {
  final int totalCommitments;
  final int completedCommitments;
  final int missedCommitments;
  final int reflectionCount;
  final double completionRate;
  final double reflectionRate;
  final String headline;
  final String detail;

  const GrowthInsight({
    required this.totalCommitments,
    required this.completedCommitments,
    required this.missedCommitments,
    required this.reflectionCount,
    required this.completionRate,
    required this.reflectionRate,
    required this.headline,
    required this.detail,
  });
}
