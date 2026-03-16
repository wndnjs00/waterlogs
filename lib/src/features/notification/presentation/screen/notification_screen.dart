import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/notification/domain/model/notification_model.dart';
import 'package:waterlogs/src/features/notification/presentation/di/notification_providers.dart';
import 'package:waterlogs/src/features/notification/presentation/viewmodel/notification_state.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  static const routePath = '/notification';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<NotificationState>(
      notificationViewModelProvider,
      (prev, next) {
        final msg = next.toastMessage;
        if (msg != null && msg.isNotEmpty && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
          ref.read(notificationViewModelProvider.notifier).clearToast();
        }
      },
    );
    final state = ref.watch(notificationViewModelProvider);
    final viewModel = ref.read(notificationViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.mainBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: state.notifications.length,
          itemBuilder: (context, index) {
            final item = state.notifications[index];
            return _NotificationItem(
              item: item,
              time: viewModel.formatTime(item.createdAt),
              onTap: () {
                if (!item.isRead) {
                  viewModel.markAsRead(item.id);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.item,
    required this.time,
    required this.onTap,
  });

  final NotificationModel item;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mainColor = item.isRead ? Colors.grey : AppColors.mainBlue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.water_drop,
                  color: mainColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
