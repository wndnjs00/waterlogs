import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waterlogs/src/core/router/app_routes.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/asset_path.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static Future<void> _handleSocialLogin(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) {
        ref.read(authViewModelProvider.notifier).showOAuthError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    // 에러 토스트
    ref.listen<AuthViewState>(authViewModelProvider, (previous, next) {
      final msg = next.toastMessage;
      if (msg != null && msg.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        ref.read(authViewModelProvider.notifier).clearToast();
      }
    });

    // 자동 로그인: 이미 로그인된 유저가 있으면 메인으로 이동
    ref.listen<AuthViewState>(authViewModelProvider, (previous, next) {
      if (previous?.user == null && next.user != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${next.user!.name}님 환영합니다')),
        );
        context.go(AppRoutes.main);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '워터로그',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '매일 수분섭취를 기록하세요',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 48),
              _KakaoLoginButton(
                onTap: () => _handleSocialLogin(
                  context,
                  ref,
                  () => ref.read(authViewModelProvider.notifier).signInWithKakao(),
                ),
              ),
              const SizedBox(height: 8),
              _NaverLoginButton(
                onTap: () => _handleSocialLogin(
                  context,
                  ref,
                  () => ref.read(authViewModelProvider.notifier).signInWithNaver(),
                ),
              ),
              const SizedBox(height: 8),
              _GoogleLoginButton(
                onTap: () => _handleSocialLogin(
                  context,
                  ref,
                  () => ref.read(authViewModelProvider.notifier).signInWithGoogle(),
                ),
              ),
              const SizedBox(height: 8),

              _EmailSignUpButton(
                onTap: () {
                  ref.read(authViewModelProvider.notifier).resetSignUpState();
                  context.push(AppRoutes.signUp);
                },
              ),

              const SizedBox(height: 40),

              const Text(
                '이미 회원이신가요?',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),

              const SizedBox(height: 4),

              GestureDetector(
                onTap: () {
                  // 이메일 로그인 화면으로 들어가기 전에 이전 에러 상태 초기화
                  ref.read(authViewModelProvider.notifier).resetSignInState();
                  context.push(AppRoutes.signIn);
                },
                child: const Text(
                  '기존 계정으로 로그인하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
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

class _KakaoLoginButton extends StatelessWidget {
  const _KakaoLoginButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Image.asset(
          AssetPath.kakaoLoginIcon,
          fit: BoxFit.fitWidth,
          errorBuilder: (_, __, ___) => Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.kakaoYellow,
            ),
            alignment: Alignment.center,
            child: const Text(
              '카카오톡 로그인',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NaverLoginButton extends StatelessWidget {
  const _NaverLoginButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.naverGreen,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 4,
              child: Image.asset(
                AssetPath.naverLoginIcon,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const SizedBox(width: 32, height: 32),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                '네이버 로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.googleGray,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 4,
              child: Image.asset(
                AssetPath.googleLoginIcon,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const SizedBox(width: 32, height: 32),
              ),
            ),
            const Text(
              'Google 계정으로 로그인',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailSignUpButton extends StatelessWidget {
  const _EmailSignUpButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.emailGray,
        ),
        alignment: Alignment.center,
        child: const Text(
          '이메일로 회원가입',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}