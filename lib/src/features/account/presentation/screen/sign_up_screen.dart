import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/core/validator/auth_validator.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/email_auth_state.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool allChecked = false;
    bool termsChecked = false;
    bool privacyChecked = false;

    ref.listen<AuthViewState>(
      authViewModelProvider,
      (previous, next) {
        if (previous?.signUpState.status != EmailAuthState.success &&
            next.signUpState.status == EmailAuthStatus.success) {
          viewModel.resetSignUpState();
          Navigator.of(context).pop(); // 가입 완료 후 이전 화면(로그인)으로
        }
      },
    );

    final isLoading = state.signUpState.status == EmailAuthStatus.loading;

    return StatefulBuilder(
      builder: (context, setState) {
        final email = emailController.text.trim();
        final password = passwordController.text;
        final confirmPassword = confirmPasswordController.text;

        final isValidEmail = AuthValidator.isValidEmail(email);
        final isValidPassword = AuthValidator.isValidPassword(password);

        final isPasswordMatch = password.isNotEmpty && password == confirmPassword;
        final isFormValid = isValidEmail && isValidPassword && isPasswordMatch && termsChecked && privacyChecked;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '이메일로 회원가입',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                    ),
                  ),
            
                  const SizedBox(height: 8),
            
                  const Text(
                    '워터로그와 함께 건강한 수분 섭취를 시작하세요',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      hintText: 'example@email.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (email.isNotEmpty && !isValidEmail)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '이메일 주소형식에 맞게 입력해주세요',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      hintText: '8자 이상, 영문+숫자+특수문자 포함',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (password.isNotEmpty && !isValidPassword)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '비밀번호는 8자 이상이며, 영문/숫자/특수문자를 모두 포함해야 합니다',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: '비밀번호 확인',
                      hintText: '비밀번호를 한번더 입력해주세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (!isPasswordMatch && confirmPassword.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '비밀번호가 일치하지 않습니다',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Checkbox(
                        value: allChecked,
                        onChanged: (checked) {
                          setState(() {
                            allChecked = checked ?? false;
                            termsChecked = allChecked;
                            privacyChecked = allChecked;
                          });
                        },
                      ),
                      const Text(
                        '전체 동의',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: termsChecked,
                            onChanged: (checked) {
                              setState(() {
                                termsChecked = checked ?? false;
                                allChecked = termsChecked && privacyChecked;
                              });
                            },
                          ),
                          const Text('(필수) 서비스 이용약관'),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              '보기',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: privacyChecked,
                            onChanged: (checked) {
                              setState(() {
                                privacyChecked = checked ?? false;
                                allChecked = termsChecked && privacyChecked;
                              });
                            },
                          ),
                          const Text('(필수) 개인정보 처리방침'),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              '보기',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading || !isFormValid
                          ? null
                          : () {
                              viewModel.signUpWithEmail(
                                email: email,
                                password: password,
                                name: email.split('@').first,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid
                            ? AppColors.mainBlue
                            : Colors.grey[300],
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '가입하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (state.signUpState.status == EmailAuthStatus.error &&
                      state.signUpState.message != null)
                    Text(
                      state.signUpState.message!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}