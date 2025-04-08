import 'package:frontend/features/learning/models/sequence_result_response.dart';

class PoseResult {
  final String imageUrl;
  final String poseName;
  final int accuracy;
  final List<PoseFeedbackItem> feedbacks;

  PoseResult({
    required this.imageUrl,
    required this.poseName,
    required this.accuracy,
    required this.feedbacks,
  });
}
