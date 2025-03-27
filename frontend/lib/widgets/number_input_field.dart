import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import 'number_picker_wheel.dart';

class NumberInputField extends StatefulWidget {
  final int initialValue;
  final String label;
  final String suffix;
  final int minValue;
  final int maxValue;
  final Function(int) onValueChanged;
  final bool readOnly;

  const NumberInputField({
    super.key,
    required this.initialValue,
    required this.label,
    required this.suffix,
    required this.minValue,
    required this.maxValue,
    required this.onValueChanged,
    this.readOnly = true, // 기본적으로 읽기 전용으로 설정 (직접 입력 방지)
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  late TextEditingController _controller;
  late int _currentValue;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 초기값에서 숫자만 추출

    _currentValue = widget.initialValue;
    _controller = TextEditingController(
      text: '${_currentValue}${widget.suffix}',
    );

    // 포커스 변경 감지
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  // 포커스 변경 시 호출
  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showNumberPicker();
    }
  }

  // 숫자 선택기 표시
  void _showNumberPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // 전체 높이 사용
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.4, // 화면 높이의 40%
              child: Column(
                children: [
                  // 상단 바
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // 제목
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 숫자 선택 휠
                  Expanded(
                    child: NumberPickerWheel(
                      initialValue: _currentValue,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                      suffix: widget.suffix,
                      onValueChanged: (value) {
                        setState(() {
                          _currentValue = value;
                        });
                      },
                    ),
                  ),

                  // 확인 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateValue(_currentValue);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // 바텀 시트가 닫힐 때 포커스 해제
      _focusNode.unfocus();
    });
  }

  // 값 업데이트
  void _updateValue(int value) {
    setState(() {
      _currentValue = value;
      _controller.text = '$value${widget.suffix}';
      widget.onValueChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.boxWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            controller: _controller,
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            // 직접 입력 방지
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.graytext,
              ),
            ),
            // 탭하면 숫자 선택기 표시
            onChanged: (value) {
              if (!widget.readOnly) {
                // 직접 입력 허용 시에만 처리
                final numericValue = int.tryParse(
                  value.replaceAll(RegExp(r'[^0-9]'), ''),
                );
                if (numericValue != null &&
                    numericValue >= widget.minValue &&
                    numericValue <= widget.maxValue) {
                  _currentValue = numericValue;
                  widget.onValueChanged(numericValue);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
