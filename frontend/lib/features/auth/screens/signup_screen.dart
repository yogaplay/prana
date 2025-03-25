import 'package:flutter/material.dart';
import 'package:frontend/features/auth/widgets/gender_selection_widget.dart';
import 'package:frontend/features/auth/widgets/info_input_field.dart';
import 'package:frontend/widgets/button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String selectedGender = '';
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
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

              Button(text: '확인', onPressed: () => {}),
            ],
          ),
        ),
      ),
    );
  }
}
