class PoseResult {
  final String imageUrl;
  final String poseName;
  final int accuracy;

  PoseResult({
    required this.imageUrl,
    required this.poseName,
    required this.accuracy,
  });
}
