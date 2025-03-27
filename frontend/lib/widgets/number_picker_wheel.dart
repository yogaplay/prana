import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NumberPickerWheel extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String suffix;
  final Function(int) onValueChanged;
  final double itemHeight;
  final int visibleItemCount;


  const NumberPickerWheel({
    super.key,
    required this.initialValue, // 초기값
    required this.minValue, // 최소값
    required this.maxValue, // 최대값
    this.suffix = '', // 뒤에 붙는 값 ex) kg, 세
    required this.onValueChanged, // 상태 변경시 호출됨
    this.itemHeight = 40.0, // 선택 영역 높이
    this.visibleItemCount = 5, // 보이는 개수 5
  });

  @override
  State<NumberPickerWheel> createState() => _NumberPickerWheelState();
}

class _NumberPickerWheelState extends State<NumberPickerWheel> {
  late FixedExtentScrollController _scrollController;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    // 초기 위치 설정 (initialValue - minValue)
    _scrollController = FixedExtentScrollController(
      initialItem: widget.initialValue - widget.minValue,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectValue(int value) {
    if (value >= widget.minValue && value <= widget.maxValue) {
      final index = value - widget.minValue;
      _scrollController.animateToItem(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _selectedValue = value;
        widget.onValueChanged(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.itemHeight * widget.visibleItemCount,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 선택된 항목 하이라이트 배경
                Positioned.fill(
                  child: Center(
                    child: Container(
                      height: widget.itemHeight,
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                // 숫자 선택 리스트
                ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: widget.itemHeight,
                  diameterRatio: 100.0, // 전체 채우기 위해 필수
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedValue = widget.minValue + index;
                      widget.onValueChanged(_selectedValue);
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: widget.maxValue - widget.minValue + 1,
                    builder: (context, index) {
                      final value = widget.minValue + index;
                      final isSelected = value == _selectedValue;

                      return GestureDetector(
                        onTap: () => _selectValue(value),
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: widget.itemHeight,
                          alignment: Alignment.center,
                          child: Text(
                            '$value${widget.suffix}',
                            style: TextStyle(
                              fontSize: isSelected ? 16 : 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.blackText : AppColors.graytext,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


