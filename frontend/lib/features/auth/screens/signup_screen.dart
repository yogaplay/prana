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
    if (selectedGender.isEmpty ||
        age == null ||
        weight == null ||
        height == null) {
      print("모든 정보가 입력되지 않음");
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
              SizedBox(height: 30),
              GenderSelectionWidget(
                selectedGender: selectedGender,
                onGenderSelected: _onGenderSelected,
              ),
              SizedBox(height: 30),
              InfoWheelField(
                label: '나이',
                unit: '세',
                minValue: 1,
                maxValue: 100,
                onChange: _onAgeChanged,
              ),
              SizedBox(height: 25),
              InfoWheelField(
                label: '체중',
                unit: 'kg',
                minValue: 30,
                maxValue: 150,
                onChange: _onWeightChanged,
              ),
              SizedBox(height: 25),
              InfoWheelField(
                label: '신장',
                unit: 'cm',
                minValue: 140,
                maxValue: 220,
                onChange: _onHeightChanged,
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
            ],
          ),
        ),
      ),
    );
  }
}
