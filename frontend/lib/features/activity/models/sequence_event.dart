class SequenceEvent {
  final int sequenceId;
  final String sequenceName;
  final String resultStatus;
  final int percent;
  final String image;

  SequenceEvent({
    required this.sequenceId,
    required this.sequenceName,
    required this.resultStatus,
    required this.percent,
    required this.image,
  });

  factory SequenceEvent.fromJson(Map<String, dynamic> json) {
    return SequenceEvent(
      sequenceId: json['sequence_id'],
      sequenceName: json['sequence_name'],
      resultStatus: json['result_status'],
      percent: json['percent'],
      image: json['image'],
    );
  }
}
