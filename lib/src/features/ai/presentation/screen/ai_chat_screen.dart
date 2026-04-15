import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/core/util/asset_path.dart';
import 'package:waterlogs/src/features/ai/presentation/di/ai_providers.dart';
import 'package:waterlogs/src/features/ai/presentation/viewmodel/ai_chat_state.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();

  static const _userBubble = Color(0xFF1976D2);
  static const _chipBg = Color(0xFFE3F2FD);
  static const _recommendList = <String>[
    '하루 권장량',
    '물 마시는 시간',
    '수분 부족 증상',
    '운동 후 수분',
    '수분 섭취 팁',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(aiChatViewModelProvider.notifier).refreshFromStorage();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed && mounted) {
      ref.read(aiChatViewModelProvider.notifier).refreshFromStorage();
    }
  }

  void _scrollTowardEnd(AiChatState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(aiChatViewModelProvider);
    final vm = ref.read(aiChatViewModelProvider.notifier);

    ref.listen(aiChatViewModelProvider, (prev, next) {
      if (next.toastMessage != null && next.toastMessage!.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.toastMessage!)),
        );
        vm.clearToast();
      }
    });

    if (state.messages.isNotEmpty || state.isLoading) {
      _scrollTowardEnd(state);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(theme: theme),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const _BotIntro(),
              const SizedBox(height: 12),
              _RecommendChips(
                list: _recommendList,
                chipBg: _chipBg,
                theme: theme,
                onTap: vm.send,
              ),
              const SizedBox(height: 12),
              ...state.messages.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ChatItem(
                    isUser: m.isUser,
                    text: m.text,
                    theme: theme,
                    userBubble: _userBubble,
                  ),
                ),
              ),
              if (state.isLoading) ...[
                const SizedBox(height: 12),
                const _LoadingChatItem(),
              ],
            ],
          ),
        ),
        ColoredBox(
          color: Colors.white,
          child: Column(
            children: [
              if (state.count >= 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '오늘 질문 횟수를 모두 사용했습니다',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              _InputBar(
                controller: _inputController,
                theme: theme,
                userBubble: _userBubble,
                enabled: _inputController.text.trim().isNotEmpty &&
                    state.count < 3 &&
                    !state.isLoading,
                onChanged: (_) => setState(() {}),
                onSend: () {
                  final t = _inputController.text;
                  vm.send(t);
                  _inputController.clear();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI 수분 섭취 도우미',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '⚠ AI 질문은 하루 3번으로 제한됩니다.\nAI 답변은 정확하지 않을 수 있어요.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _AiProfile extends StatelessWidget {
  const _AiProfile();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 36,
        height: 36,
        child: Image.asset(
          AssetPath.aiWitiIcon,
          fit: BoxFit.cover,
          alignment: const Alignment(-0.15, 0),
          gaplessPlayback: true,
          errorBuilder: (context, _, __) {
            return const ColoredBox(
              color: Color(0xFFE3F2FD),
              child: Center(
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 18,
                  color: Color(0xFF1976D2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BotIntro extends StatelessWidget {
  const _BotIntro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AiProfile(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('위티', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '안녕하세요! 어떤 점이 궁금하세요?',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendChips extends StatelessWidget {
  const _RecommendChips({
    required this.list,
    required this.chipBg,
    required this.theme,
    required this.onTap,
  });

  final List<String> list;
  final Color chipBg;
  final ThemeData theme;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < list.length; i += 2) {
      final pair = list.sublist(i, i + 2 > list.length ? list.length : i + 2);
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pair
              .map(
                (label) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: Material(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => onTap(label),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          label,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rows,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  const _ChatItem({
    required this.isUser,
    required this.text,
    required this.theme,
    required this.userBubble,
  });

  final bool isUser;
  final String text;
  final ThemeData theme;
  final Color userBubble;

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: userBubble,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AiProfile(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('위티', style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(text, style: theme.textTheme.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingChatItem extends StatefulWidget {
  const _LoadingChatItem();

  @override
  State<_LoadingChatItem> createState() => _LoadingChatItemState();
}

class _LoadingChatItemState extends State<_LoadingChatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AiProfile(),
        const SizedBox(width: 6),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final n = (1 + _controller.value * 2).round().clamp(1, 3);
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('.' * n),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.theme,
    required this.userBubble,
    required this.enabled,
    required this.onChanged,
    required this.onSend,
  });

  final TextEditingController controller;
  final ThemeData theme;
  final Color userBubble;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  maxLines: 1,
                  style: theme.textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '수분 섭취에 대해 질문해보세요.',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: enabled ? userBubble : Colors.grey.shade300,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
