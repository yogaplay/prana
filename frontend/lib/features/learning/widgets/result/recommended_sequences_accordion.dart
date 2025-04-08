import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/widgets/yoga_carousel.dart';

class RecommendedSequencesAccordion extends StatefulWidget {
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
    final bodyF = widget.bodyF;
    final bodyS = widget.bodyS;

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
