import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/profile_providers.dart';
import 'package:frontend/features/profile/screens/edit_age_screen.dart';
import 'package:frontend/features/profile/screens/edit_height_screen.dart';
import 'package:frontend/features/profile/screens/edit_nickname_screen.dart';
import 'package:frontend/features/profile/screens/edit_weight_screen.dart';
import '../../../constants/app_colors.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackText,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '내 정보 수정',
          style: TextStyle(
            color: AppColors.blackText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: profileState.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '프로필을 불러올 수 없습니다.',
                    style: TextStyle(fontSize: 16, color: AppColors.graytext),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(profileNotifierProvider.notifier).loadProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('프로필 정보가 없습니다.'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '닉네임 변경',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    title: profile.nickname ?? '닉네임을 설정해주세요',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder:
                              (context) => EditNicknameScreen(
                                initialNickname: profile.nickname ?? '',
                              ),
                        ),
                      );
                      if (result != null) {
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .updateNickname(result);
                        if (mounted) {
                          ref
                              .read(profileNotifierProvider.notifier)
                              .loadProfile();
                          _showUpdateSuccess(context);
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    '정보 변경',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    title: '나이',
                    value: profile.age,
                    suffix: '세',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder:
                              (context) =>
                                  EditAgeScreen(initialAge: profile.age ?? 25),
                        ),
                      );
                      if (result != null) {
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .updateAge(result);
                        if (mounted) {
                          ref
                              .read(profileNotifierProvider.notifier)
                              .loadProfile();
                          _showUpdateSuccess(context);
                        }
                      }
                    },
                  ),
                  _buildInfoField(
                    title: '신장',
                    value: profile.height,
                    suffix: 'cm',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder:
                              (context) => EditHeightScreen(
                                initialHeight: profile.height ?? 170,
                              ),
                        ),
                      );
                      if (result != null) {
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .updateHeight(result);
                        if (mounted) {
                          ref
                              .read(profileNotifierProvider.notifier)
                              .loadProfile();
                          _showUpdateSuccess(context);
                        }
                      }
                    },
                  ),
                  _buildInfoField(
                    title: '체중',
                    value: profile.weight,
                    suffix: 'kg',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder:
                              (context) => EditWeightScreen(
                                initialWeight: profile.weight ?? 60,
                              ),
                        ),
                      );
                      if (result != null) {
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .updateWeight(result);
                        if (mounted) {
                          ref
                              .read(profileNotifierProvider.notifier)
                              .loadProfile();
                          _showUpdateSuccess(context);
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    '성별 선택',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.boxWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (profile.gender != 'M') {
                                await ref
                                    .read(profileNotifierProvider.notifier)
                                    .updateGender('M');
                                if (mounted) {
                                  ref
                                      .read(profileNotifierProvider.notifier)
                                      .loadProfile();
                                  _showUpdateSuccess(context);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    profile.gender == 'M'
                                        ? AppColors.primary
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      profile.gender == 'M'
                                          ? AppColors.primary
                                          : AppColors.lightGray,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '남성',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        profile.gender == 'M'
                                            ? Colors.white
                                            : AppColors.blackText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (profile.gender != 'F') {
                                await ref
                                    .read(profileNotifierProvider.notifier)
                                    .updateGender('F');
                                if (mounted) {
                                  ref
                                      .read(profileNotifierProvider.notifier)
                                      .loadProfile();
                                  _showUpdateSuccess(context);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    profile.gender == 'F'
                                        ? AppColors.primary
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      profile.gender == 'F'
                                          ? AppColors.primary
                                          : AppColors.lightGray,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '여성',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        profile.gender == 'F'
                                            ? Colors.white
                                            : AppColors.blackText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoField({
    String? title,
    int? value,
    String? suffix,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                if (value == null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.blackText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, color: AppColors.graytext, size: 20),
                ] else ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.blackText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$value$suffix',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.blackText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.graytext,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('정보가 업데이트되었습니다.'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
