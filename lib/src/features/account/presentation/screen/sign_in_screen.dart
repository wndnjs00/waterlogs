import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waterlogs/src/core/router/app_routes.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/provider/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/email_auth_state.dart';

import '../../../../core/theme/app_colors.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static final _emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
  static final _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*()_+=-]).{8,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);

    ref.listen<AuthViewState>(authViewModelProvider, (previous, next) {
      if (previous?.signInState.status != EmailAuthState.success &&
          next.signInState.status == EmailAuthStatus.success) {
        viewModel.resetSignInState();
        context.go(AppRoutes.main);
      }
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final isValidEmail = _emailRegex.hasMatch(email);
    final isValidPassword = _passwordRegex.hasMatch(password);
    final isFormValid = isValidEmail && isValidPassword && email.isNotEmpty && password.isNotEmpty;
    final isLoading = state.signInState.status == EmailAuthStatus.loading;

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
              const SizedBox(height: 100),
              const Text(
                '이메일로 로그인',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '워터로그와 함께 건강한 수분 섭취를 시작하세요',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 80),
              TextField(
                controller: _emailController,
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
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
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
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isFormValid && !isLoading
                      ? () {
                          viewModel.signInWithEmail(
                            email: email,
                            password: password,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid && !isLoading
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
                          '로그인 하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              if (state.signInState.status == EmailAuthStatus.error &&
                  state.signInState.message != null)
                Text(
                  state.signInState.message!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}