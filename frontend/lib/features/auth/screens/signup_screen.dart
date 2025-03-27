import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/widgets/gender_selection_widget.dart';
import 'package:frontend/features/auth/widgets/info_input_field.dart';
import 'package:frontend/widgets/button.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String selectedGender = '';
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  Future<void> _onSignup() async {
    if (selectedGender.isEmpty ||
        ageController.text.isEmpty ||
        weightController.text.isEmpty ||
        heightController.text.isEmpty) {
      print("모든 정보가 입력되지 않음");
      return;
    }

    try {
      final signupService = ref.read(signupServiceProvider);

      await signupService.signUp(
        gender: selectedGender,
        age: ageController.text,
        weight: weightController.text,
        height: heightController.text,
      );

      context.goNamed("home");
    } catch (e) {
      print("회원가입 실패: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
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
              InfoInputField(
                label: '나이',
                controller: ageController,
                unit: '세',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 25),
              InfoInputField(
                label: '체중',
                controller: weightController,
                unit: 'kg',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 25),
              InfoInputField(
                label: '신장',
                controller: heightController,
                unit: 'cm',
                keyboardType: TextInputType.number,
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
