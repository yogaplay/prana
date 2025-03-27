class Report {
  final int userId;
  final String nickname;
  final int streakDays;
  final int totalTime;
  final int totalYogaCnt;

  Report({
    required this.userId,
    required this.nickname,
    required this.streakDays,
    required this.totalTime,
    required this.totalYogaCnt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      userId: json['userId'],
      nickname: json['nickname'],
      streakDays: json['streakDays'],
      totalTime: json['totalTime'],
      totalYogaCnt: json['totalYogaCnt'],
    );
  }
}

class RecentItem {
  final int sequenceId;
  final int userSequenceId;
  final String sequenceName;
  final String image;
  final String resultStatus;
  final int percent;
  final DateTime updatedAt;

  RecentItem({
    required this.sequenceId,
    required this.userSequenceId,
    required this.sequenceName,
    required this.image,
    required this.resultStatus,
    required this.percent,
    required this.updatedAt,
  });

  factory RecentItem.fromJson(Map<String, dynamic> json) {
    return RecentItem(
      sequenceId: json['sequenceId'],
      userSequenceId: json['userSequenceId'],
      sequenceName: json['sequenceName'],
      image: json['image'],
      resultStatus: json['resultStatus'],
      percent: json['percent'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class StarItem {
  final int sequenceId;
  final String sequenceName;
  final String? image;
  final bool star;
  final List<String> tagList;

  StarItem({
    required this.sequenceId,
    required this.sequenceName,
    this.image,
    required this.star,
    required this.tagList,
  });

  factory StarItem.fromJson(Map<String, dynamic> json) {
    return StarItem(
      sequenceId: json['sequenceId'],
      sequenceName: json['sequenceName'],
      image: json['image'],
      star: json['star'],
      tagList: List<String>.from(json['tagList']),
    );
  }
}

class ReportResponse {
  final Report report;
  final List<RecentItem> recentList;
  final List<StarItem> starList;

  ReportResponse({
    required this.report,
    required this.recentList,
    required this.starList,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      report: Report.fromJson(json['report']),
      recentList: (json['recentList'] as List)
          .map((item) => RecentItem.fromJson(item))
          .toList(),
      starList: (json['starList'] as List)
          .map((item) => StarItem.fromJson(item))
          .toList(),
    );
  }
}

class SequenceItem {
  final int sequenceId;
  final String sequenceName;
  final String? image;
  final bool star;
  final List<String> tagList;

  SequenceItem({
    required this.sequenceId,
    required this.sequenceName,
    this.image,
    required this.star,
    required this.tagList,
  });

  factory SequenceItem.fromJson(Map<String, dynamic> json) {
    return SequenceItem(
      sequenceId: json['sequenceId'],
      sequenceName: json['sequenceName'],
      image: json['image'],
      star: json['star'],
      tagList: List<String>.from(json['tagList']),
    );
  }
}


class PaginatedSequenceResponse {
  final List<SequenceItem> content;
  final int currentPage;
  final int pageSize;
  final int totalElements;
  final int totalPages;

  PaginatedSequenceResponse({
    required this.content,
    required this.currentPage,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
  });

  factory PaginatedSequenceResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedSequenceResponse(
      content: (json['content'] as List)
          .map((item) => SequenceItem.fromJson(item))
          .toList(),
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}
