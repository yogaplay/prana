import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/number_picker_wheel.dart';

class InfoWheelField extends StatefulWidget {
  final String label;
  final String unit;
  final int minValue;
  final int maxValue;
  final Function(int) onChange;

  const InfoWheelField({
    super.key,
    required this.label,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.onChange,
  });

  @override
  State<InfoWheelField> createState() => _InfoWheelFieldState();
}

class _InfoWheelFieldState extends State<InfoWheelField> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.blackText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              _showNumberPicker(context);
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.boxWhite,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Color(0xFFF4F4F4), width: 1.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child:
                          selectedValue != null
                              ? Text(
                                selectedValue.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : Container(), // 선택 전에는 빈 컨테이너
                    ),
                  ),
                  Text(
                    widget.unit,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.graytext,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNumberPicker(BuildContext context) {
    int currentValue = selectedValue ?? widget.minValue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.4,
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
                      initialValue: currentValue,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                      suffix: widget.unit,
                      onValueChanged: (value) {
                        setState(() {
                          currentValue = value;
                        });
                      },
                    ),
                  ),

                  // 확인 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        this.setState(() {
                          selectedValue = currentValue;
                        });
                        widget.onChange(currentValue);
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
    );
  }
}
