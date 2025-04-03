import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/widgets/yoga_carousel.dart';

class RecommendedSequencesAccordion extends StatefulWidget {
  final List<YogaItem> recommendedSequences;

  const RecommendedSequencesAccordion({
    super.key,
    required this.recommendedSequences,
  });

  @override
  State<RecommendedSequencesAccordion> createState() =>
      _RecommendedSequencesAccordionState();
}

class _RecommendedSequencesAccordionState
    extends State<RecommendedSequencesAccordion> {
  bool _isExpanded = false;
  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '이런 요가 어떠세요?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              _isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
            ),
            onTap: _toggle,
          ),
          if (_isExpanded) ...[
            YogaCarousel(
              title: '팔',
              items: widget.recommendedSequences,
              tagType: '운동 부위',
            ),
            YogaCarousel(
              title: '코어',
              items: widget.recommendedSequences,
              tagType: '운동 부위',
            ),
          ],
        ],
      ),
    );
  }
}
