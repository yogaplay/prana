class SequenceDetailModel {
  final int sequenceId;
  final String sequenceName;
  final String sequenceImage;
  final String description;
  final int time;
  final int yogaCnt;
  final bool star;
  final String music;
  final List<YogaModel> yogaSequence;

  SequenceDetailModel({
    required this.sequenceId,
    required this.sequenceName,
    required this.sequenceImage,
    required this.description,
    required this.time,
    required this.yogaCnt,
    required this.star,
    required this.music,
    required this.yogaSequence,
  });

  factory SequenceDetailModel.fromJson(Map<String, dynamic> json) {
    return SequenceDetailModel(
      sequenceId: json['sequenceId'] as int,
      sequenceName: json['sequenceName'] as String,
      sequenceImage: json['sequenceImage'] as String,
      description: json['description'] as String,
      time: json['time'] as int,
      yogaCnt: json['yogaCnt'] as int,
      star: json['star'] as bool,
      music: json['music'] as String,
      yogaSequence:
          (json['yogaSequence'] as List<dynamic>)
              .map((e) => YogaModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sequenceId': sequenceId,
      'sequenceName': sequenceName,
      'sequenceImage': sequenceImage,
      'description': description,
      'time': time,
      'yogaCnt': yogaCnt,
      'star': star,
      'music': music,
      'yogaSequence': yogaSequence.map((e) => e.toJson()).toList(),
    };
  }
}

class YogaModel {
  final int yogaId;
  final String yogaName;
  final String video;
  final String? description;
  final String image;
  final int yogaTime;

  YogaModel({
    required this.yogaId,
    required this.yogaName,
    required this.video,
    required this.description,
    required this.image,
    required this.yogaTime,
  });

  factory YogaModel.fromJson(Map<String, dynamic> json) {
    return YogaModel(
      yogaId: json['yogaId'] as int,
      yogaName: json['yogaName'] as String,
      video: json['video'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String,
      yogaTime: json['yogaTime'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yogaId': yogaId,
      'yogaName': yogaName,
      'video': video,
      'description': description,
      'image': image,
      'yogaTime': yogaTime,
    };
  }
}
