class MusicModel {
  final int musicId;
  final String musicLocation;
  final String name;

  MusicModel({
    required this.musicId,
    required this.musicLocation,
    required this.name,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      musicId: json['musicId'],
      musicLocation: json['musicLocation'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'musicId': musicId, 'musicLocation': musicLocation, 'name': name};
  }
}
