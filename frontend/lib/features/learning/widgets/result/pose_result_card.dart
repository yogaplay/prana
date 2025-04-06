import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/models/pose_result.dart';
import 'package:frontend/features/learning/models/sequence_result_response.dart';

final double centerX = 43.4;

class PoseResultCard extends StatefulWidget {
  final PoseResult result;

  const PoseResultCard({super.key, required this.result});

  @override
  State<PoseResultCard> createState() => _PoseResultCardState();
}

class _PoseResultCardState extends State<PoseResultCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late TabController _tabController;
  int _currentTapIndex = 0;

  final List<String> feedbackGroups = ['등', '코어', '팔', '다리'];

  final Map<String, String> partNameMap = {
    'SHOULDER': '어깨',
    'ELBOW_LEFT': '왼쪽 팔꿈치',
    'ELBOW_RIGHT': '오른쪽 팔꿈치',
    'ARM_LEFT': '왼팔',
    'ARM_RIGHT': '오른팔',
    'HIP_LEFT': '왼쪽 엉덩이',
    'HIP_RIGHT': '오른쪽 엉덩이',
    'KNEE_LEFT': '왼쪽 무릎',
    'KNEE_RIGHT': '오른쪽 무릎',
    'LEG_LEFT': '왼쪽 다리',
    'LEG_RIGHT': '오른쪽 다리',
  };

  final Map<String, String> feedbackMessageMap = {
    'SHOULDER': '자세가 불안정했습니다.',
    'ELBOW_LEFT': '팔의 위치가 흔들렸습니다.',
    'ELBOW_RIGHT': '팔의 위치가 흔들렸습니다.',
    'ARM_LEFT': '팔의 위치가 흔들렸습니다.',
    'ARM_RIGHT': '팔의 위치가 흔들렸습니다.',
    'HIP_LEFT': '골반의 정렬이 무너졌습니다.',
    'HIP_RIGHT': '골반의 정렬이 무너졌습니다.',
    'KNEE_LEFT': '무게 중심이 흔들렸습니다.',
    'KNEE_RIGHT': '무게 중심이 흔들렸습니다.',
    'LEG_LEFT': '하체 균형이 흐트러졌습니다.',
    'LEG_RIGHT': '하체 균형이 흐트러졌습니다.',
  };

  final Map<String, Offset> partOffsets = {
    'LEFT_SHOULDER': Offset(centerX - 20, 47),
    'RIGHT_SHOULDER': Offset(centerX + 20, 47),
    'ELBOW_LEFT': Offset(centerX - 25, 85),
    'ELBOW_RIGHT': Offset(centerX + 25, 85),
    'ARM_LEFT': Offset(centerX - 18, 63),
    'ARM_RIGHT': Offset(centerX + 18, 63),
    'HIP_LEFT': Offset(centerX - 10, 107),
    'HIP_RIGHT': Offset(centerX + 10, 107),
    'KNEE_LEFT': Offset(centerX - 10, 147),
    'KNEE_RIGHT': Offset(centerX + 10, 147),
    'LEG_LEFT': Offset(centerX - 9, 120),
    'LEG_RIGHT': Offset(centerX + 9, 120),
  };

  final Map<String, String> partGroupMap = {
    'SHOULDER': '등',
    'HIP_LEFT': '코어',
    'HIP_RIGHT': '코어',
    'ARM_LEFT': '팔',
    'ARM_RIGHT': '팔',
    'ELBOW_LEFT': '팔',
    'ELBOW_RIGHT': '팔',
    'LEG_LEFT': '다리',
    'LEG_RIGHT': '다리',
    'KNEE_LEFT': '다리',
    'KNEE_RIGHT': '다리',
  };

  late Map<String, List<PoseFeedbackItem>> groupedFeedbacks;

  @override
  void initState() {
    super.initState();
    groupedFeedbacks = {'등': [], '코어': [], '팔': [], '다리': []};
    for (final f in widget.result.feedbacks) {
      final group = partGroupMap[f.feedback];
      if (group != null) groupedFeedbacks[group]!.add(f);
    }
    _tabController = TabController(length: feedbackGroups.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTapIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.result.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.result.poseName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '정확도 ${widget.result.accuracy}%',
                      style: TextStyle(fontSize: 16, color: AppColors.graytext),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.graytext,
                ),
              ),
            ],
          ),
          if (_isExpanded) ...[
            DefaultTabController(
              length: feedbackGroups.length,
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/man-body.png',
                            width: 86.8,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          ..._buildPositionedCircles(),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelColor: AppColors.primary,
                              unselectedLabelColor: AppColors.graytext,
                              indicatorColor: AppColors.primary,
                              tabs:
                                  feedbackGroups
                                      .map((e) => Tab(text: e))
                                      .toList(),
                            ),
                            SizedBox(height: 4),
                            SizedBox(
                              height: 152,
                              child: TabBarView(
                                controller: _tabController,
                                children:
                                    feedbackGroups.map((groupName) {
                                      final groupItems =
                                          groupedFeedbacks[groupName] ?? [];
                                      if (groupItems.isEmpty) {
                                        return Center(
                                          child: Text('해당 부위에 불안정한 자세가 없습니다.'),
                                        );
                                      }
                                      return SingleChildScrollView(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              groupItems.map((f) {
                                                final partKey = f.feedback;
                                                final partName =
                                                    partNameMap[partKey] ??
                                                    partKey;
                                                final message =
                                                    feedbackMessageMap[partKey] ??
                                                    '자세가 불안정했습니다.';
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: 12,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '$partName: ${f.feedbackCnt}회',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        message,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              AppColors
                                                                  .graytext,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildPositionedCircles() {
    final selectedGroup = feedbackGroups[_currentTapIndex];
    final feedbacks = groupedFeedbacks[selectedGroup] ?? [];

    return feedbacks.expand((f) {
      if (f.feedback == 'SHOULDER') {
        return ['LEFT_SHOULDER', 'RIGHT_SHOULDER'].map((side) {
          final offset = partOffsets[side];
          if (offset == null) return SizedBox();
          return _buildDot(offset);
        });
      } else {
        final offset = partOffsets[f.feedback];
        if (offset == null) return [SizedBox()];
        return [_buildDot(offset)];
      }
    }).toList();
  }

  Widget _buildDot(Offset offset) {
    return Positioned(
      left: offset.dx - 8,
      top: offset.dy - 8,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha((0.3 * 255).toInt()),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
