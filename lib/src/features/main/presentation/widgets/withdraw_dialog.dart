import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waterlogs/src/core/router/app_routes.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/account/domain/model/user_info.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';

void showWithdrawDialog({
  required BuildContext context,
  required WidgetRef ref,
  required LoginProvider? loginProvider,
}) {
  if (loginProvider == null) return;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => _WithdrawDialogContent(
      parentContext: context,
      dialogContext: dialogContext,
      ref: ref,
      loginProvider: loginProvider,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원탈퇴 완료')),
        );
        context.go(AppRoutes.login);
      },
      onCancel: () => Navigator.of(dialogContext).pop(),
    ),
  );
}

class _WithdrawDialogContent extends StatefulWidget {
  const _WithdrawDialogContent({
    required this.parentContext,
    required this.dialogContext,
    required this.ref,
    required this.loginProvider,
    required this.onSuccess,
    required this.onCancel,
  });

  final BuildContext parentContext;
  final BuildContext dialogContext;
  final WidgetRef ref;
  final LoginProvider loginProvider;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  @override
  State<_WithdrawDialogContent> createState() => _WithdrawDialogContentState();
}

class _WithdrawDialogContentState extends State<_WithdrawDialogContent> {
  bool _isEmailPasswordStep = false;
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onConfirmTap() async {
    if (widget.loginProvider == LoginProvider.email && !_isEmailPasswordStep) {
      setState(() => _isEmailPasswordStep = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.ref.read(authViewModelProvider.notifier).deleteAccount(
            widget.loginProvider,
            emailReauthPassword: _isEmailPasswordStep ? _passwordController.text : null,
          );
      if (!mounted) return;
      Navigator.of(widget.dialogContext).pop();
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(
          content: Text(e is StateError ? e.message : '회원탈퇴 실패'),
        ),
      );
    }
  }

  void _onCancelTap() {
    if (_isEmailPasswordStep) {
      setState(() {
        _isEmailPasswordStep = false;
        _passwordController.clear();
      });
    } else {
      widget.onCancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    const dialogTextColor = Colors.black;
    const cancelBorderGray = AppColors.circularProgressGray;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '정말 탈퇴하시겠습니까?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: dialogTextColor,
              ),
            ),
            const SizedBox(height: 12),
            if (_isEmailPasswordStep) ...[
              const Text(
                '본인 확인을 위해 비밀번호를 입력해주세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: dialogTextColor,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                enabled: !_isLoading,
              ),
            ] else
              const Text(
                '탈퇴시 계정과 저장된 사항이 모두 삭제되며,\n복구되지 않습니다. 계속 진행하시겠습니까?',
                style: TextStyle(
                  fontSize: 14,
                  color: dialogTextColor,
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _onCancelTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: cancelBorderGray),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('취소', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _onConfirmTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mainBlue,
                      side: const BorderSide(color: AppColors.mainBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('탈퇴하기', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
