import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/widgets/gender_selection_widget.dart';
import 'package:frontend/features/auth/widgets/info_wheel_field.dart'; // 새로운 위젯으로 변경
import 'package:frontend/widgets/button.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String selectedGender = '';
  int? age;
  int? weight;
  int? height;

  bool _attemptedSubmit = false;

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void _onAgeChanged(int value) {
    setState(() {
      age = value;
    });
  }

  void _onWeightChanged(int value) {
    setState(() {
      weight = value;
    });
  }

  void _onHeightChanged(int value) {
    setState(() {
      height = value;
    });
  }

  Future<void> _onSignup() async {
    setState(() {
      _attemptedSubmit = true;
    });

    if (selectedGender.isEmpty ||
        age == null ||
        weight == null ||
        height == null) {
      // 스크롤을 맨 위로 올려서 모든 오류를 볼 수 있게 함
      ScrollController().animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    try {
      final signupService = ref.read(signupServiceProvider);

      await signupService.signUp(
        gender: selectedGender,
        age: age.toString(),
        weight: weight.toString(),
        height: height.toString(),
      );

      context.goNamed("home");
    } catch (e) {
      print("회원가입 실패: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '더 나은 맞춤 서비스를 위해\n추가 정보를 입력해주세요! 😊',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 성별 선택 영역 (라벨 없음)
              GenderSelectionWidget(
                selectedGender: selectedGender,
                onGenderSelected: _onGenderSelected,
              ),
              // 고정된 높이의 오류 메시지 컨테이너
              Container(
                height: 20, // 고정 높이
                padding: const EdgeInsets.only(left: 32.0),
                alignment: Alignment.centerLeft,
                child:
                    _attemptedSubmit && selectedGender.isEmpty
                        ? Text(
                          '성별을 선택해주세요',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        )
                        : null, // 오류가 없을 때는 빈 공간 유지
              ),

              SizedBox(height: 20),

              // 나이, 체중, 신장 입력 필드
              InfoWheelField(
                label: '나이',
                unit: '세',
                minValue: 1,
                maxValue: 100,
                onChange: _onAgeChanged,
                showError: _attemptedSubmit && age == null,
              ),
              SizedBox(height: 20),
              InfoWheelField(
                label: '체중',
                unit: 'kg',
                minValue: 30,
                maxValue: 150,
                onChange: _onWeightChanged,
                showError: _attemptedSubmit && weight == null,
              ),
              SizedBox(height: 20),
              InfoWheelField(
                label: '신장',
                unit: 'cm',
                minValue: 140,
                maxValue: 220,
                onChange: _onHeightChanged,
                showError: _attemptedSubmit && height == null,
              ),
              SizedBox(height: 45),

              Button(text: '확인', onPressed: _onSignup),
              SizedBox(height: 7),
              TextButton(
                onPressed: () {
                  context.goNamed("home");
                },
                child: Text(
                  '나중에 입력하기',
                  style: TextStyle(
                    color: AppColors.graytext,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
