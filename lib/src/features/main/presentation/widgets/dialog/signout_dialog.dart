import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waterlogs/src/core/router/app_routes.dart';
import 'package:waterlogs/src/features/account/domain/model/user_info.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';

import 'waterlog_base_dialog.dart';

void signOutDialog({
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('회원탈퇴 완료')));
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
      await widget.ref
          .read(authViewModelProvider.notifier)
          .deleteAccount(
            widget.loginProvider,
            emailReauthPassword: _isEmailPasswordStep
                ? _passwordController.text
                : null,
          );

      if (!mounted) return;

      Navigator.of(widget.dialogContext).pop();
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        widget.parentContext,
      ).showSnackBar(const SnackBar(content: Text('회원탈퇴 실패')));
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
    return WaterLogBaseDialog(
      title: '정말 탈퇴하시겠습니까?',
      confirmText: '탈퇴하기',
      cancelText: '취소',
      onConfirm: _onConfirmTap,
      onCancel: _onCancelTap,
      isLoading: _isLoading,
      content: _isEmailPasswordStep
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '본인 확인을 위해 비밀번호를 입력해주세요.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
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
              ],
            )
          : const Text(
              '탈퇴시 계정과 저장된 사항이 모두 삭제되며,\n복구되지 않습니다. 계속 진행하시겠습니까?',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
    );
  }
}
