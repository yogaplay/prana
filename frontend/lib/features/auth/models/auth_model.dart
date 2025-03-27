class AuthResponse {
  final String pranaAccessToken;
  final String pranaRefreshToken;
  final bool isFirst;

  AuthResponse({
    required this.pranaAccessToken,
    required this.pranaRefreshToken,
    required this.isFirst,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      pranaAccessToken: json['pranaAccessToken'],
      pranaRefreshToken: json['pranaRefreshToken'],
      isFirst: json['isFirst'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pranaAccessToken': pranaAccessToken,
      'pranaRefreshToken': pranaRefreshToken,
      'isFirst': isFirst,
    };
  }
}

class RefreshResponse {
  final String pranaAccessToken;

  RefreshResponse({required this.pranaAccessToken});

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(pranaAccessToken: json['pranaAccessToken']);
  }

  Map<String, dynamic> toJson() {
    return {'pranaAccessToken': pranaAccessToken};
  }
}
