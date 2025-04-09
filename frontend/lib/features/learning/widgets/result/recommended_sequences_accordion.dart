import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/profile_providers.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/widgets/yoga_carousel.dart';

class RecommendedSequencesAccordion extends ConsumerStatefulWidget {
  final String bodyF;
  final String bodyS;
  final List<YogaItem> sequencesF;
  final List<YogaItem> sequencesS;

  const RecommendedSequencesAccordion({
    super.key,
    required this.bodyF,
    required this.bodyS,
    required this.sequencesF,
    required this.sequencesS,
  });

  @override
  ConsumerState<RecommendedSequencesAccordion> createState() =>
      _RecommendedSequencesAccordionState();
}

class _RecommendedSequencesAccordionState
    extends ConsumerState<RecommendedSequencesAccordion> {
  bool _isExpanded = false;
  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyF = widget.bodyF;
    final bodyS = widget.bodyS;
    final profileAsync = ref.watch(profileProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            title: profileAsync.when(
              data:
                  (profile) => Text(
                    '${profile.nickname}님을 위한 요가',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
              loading:
                  () => Text('추천 요가 로딩 중...', style: TextStyle(fontSize: 16)),
              error: (_, __) => Text('추천 요가', style: TextStyle(fontSize: 16)),
            ),
            trailing: Icon(
              _isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
            ),
            onTap: _toggle,
          ),
          if (_isExpanded) ...[
            if (bodyF != '' && widget.sequencesF.isNotEmpty)
              YogaCarousel(
                title: bodyF,
                items: widget.sequencesF,
                tagType: '운동 부위',
              ),
            if (bodyS != '')
              YogaCarousel(
                title: bodyS,
                items: widget.sequencesS,
                tagType: '운동 부위',
              ),
          ],
        ],
      ),
    );
  }
}
