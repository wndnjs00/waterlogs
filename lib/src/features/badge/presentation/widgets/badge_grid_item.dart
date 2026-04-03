import 'package:flutter/material.dart';

import 'package:waterlogs/src/core/util/asset_path.dart';

/// 그리드 셀 높이는 기기스케일에 따라 빠듯할 수 있어, 내용 전체를 [FittedBox]로 축소해 RenderFlex 오버플로우를 방지한다.
class BadgeGridItem extends StatelessWidget {
  const BadgeGridItem({
    super.key,
    required this.isAchieved,
    required this.title,
  });

  final bool isAchieved;
  final String title;

  @override
  Widget build(BuildContext context) {
    final imagePath =
        isAchieved ? AssetPath.badgeActive : AssetPath.badgeInactive;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isAchieved
                                ? const Color(0xFF2979FF)
                                : Colors.grey,
                            fontSize: 15,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    if (isAchieved)
                      Text(
                        '획득완료',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF4CAF50),
                              fontSize: 13,
                            ),
                      )
                    else
                      Text(
                        '뱃지를 획득해보세요',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
