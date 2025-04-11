class ProfileModel {
  String? nickname;
  int? height;
  int? age;
  int? weight;
  String? gender;

  ProfileModel({
    this.nickname,
    this.height,
    this.age,
    this.weight,
    this.gender,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nickname: json['nickname'],
      height: json['height'],
      age: json['age'],
      weight: json['weight'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'height': height,
      'age': age,
      'weight': weight,
      'gender': gender,
    };
  }

  ProfileModel copyWith({
    String? nickname,
    int? height,
    int? age,
    int? weight,
    String? gender,
  }) {
    return ProfileModel(
      nickname: nickname ?? this.nickname,
      height: height ?? this.height,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
    );
  }
}
