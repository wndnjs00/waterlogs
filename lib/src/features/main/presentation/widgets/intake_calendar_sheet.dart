import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/theme/app_colors.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';
import 'package:waterlogs/src/features/main/presentation/di/water_providers.dart';

/// 월간 섭취 캘린더 (Firestore `water_logs` + 오늘 로컬/미저장 반영).
class IntakeCalendarSheet extends ConsumerStatefulWidget {
  const IntakeCalendarSheet({super.key, required this.uid});

  final String uid;

  static Future<void> show(BuildContext context, {required String uid}) {
    final maxH = MediaQuery.sizeOf(context).height * 0.92;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: maxH),
      builder: (ctx) => IntakeCalendarSheet(uid: uid),
    );
  }

  @override
  ConsumerState<IntakeCalendarSheet> createState() => _IntakeCalendarSheetState();
}

class _IntakeCalendarSheetState extends ConsumerState<IntakeCalendarSheet> {
  late DateTime _visibleMonth;
  late DateTime _selectedDay;
  Map<String, WaterLog> _byDate = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMonth(_visibleMonth));
  }

  Future<void> _loadMonth(DateTime month) async {
    setState(() => _loading = true);
    final useCase = ref.read(waterUseCaseProvider);
    var list = await useCase.logsInMonth(widget.uid, month.year, month.month);
    final todayLog = ref.read(waterViewModelProvider).todayLog;
    list = _mergeToday(list, todayLog);
    if (!mounted) return;
    setState(() {
      _byDate = {for (final l in list) l.date: l};
      _loading = false;
    });
  }

  List<WaterLog> _mergeToday(List<WaterLog> server, WaterLog? todayLog) {
    if (todayLog == null) return server;
    final rest = server.where((l) => l.date != todayLog.date).toList();
    final merged = [...rest, todayLog]..sort((a, b) => a.date.compareTo(b.date));
    return merged;
  }

  void _prevMonth() {
    final m = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    setState(() {
      _visibleMonth = m;
      if (_selectedDay.year != m.year || _selectedDay.month != m.month) {
        _selectedDay = DateTime(m.year, m.month, 1);
      }
    });
    _loadMonth(m);
  }

  void _nextMonth() {
    final m = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    setState(() {
      _visibleMonth = m;
      if (_selectedDay.year != m.year || _selectedDay.month != m.month) {
        _selectedDay = DateTime(m.year, m.month, 1);
      }
    });
    _loadMonth(m);
  }

  String _iso(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final mo = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$mo-$day';
  }

  String _titleMonth(DateTime m) => '${m.year}년 ${m.month}월';

  String _titleDetailDay(DateTime d) => '${d.year}년 ${d.month}월 ${d.day}일 섭취 기록';

  WaterLog? _logFor(DateTime day) => _byDate[_iso(day)];

  Set<BeverageType> _typesWithIntake(WaterLog? log) {
    if (log == null) return {};
    final set = <BeverageType>{};
    for (final t in BeverageType.values) {
      if ((log.beverages[t.id] ?? 0) > 0) set.add(t);
    }
    return set;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<WaterLog?>(
      waterViewModelProvider.select((s) => s.todayLog),
      (prev, next) {
        if (prev != next) _loadMonth(_visibleMonth);
      },
    );

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.paddingOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: _loading ? null : _prevMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    _titleMonth(_visibleMonth),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _loading ? null : _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              )
            else ...[
              _WeekdayHeader(),
              const SizedBox(height: 4),
              _MonthGrid(
                visibleMonth: _visibleMonth,
                selectedDay: _selectedDay,
                today: todayNorm,
                logFor: _logFor,
                typesWithIntake: _typesWithIntake,
                onSelectDay: (d) => setState(() => _selectedDay = d),
              ),
              const SizedBox(height: 16),
              _DayDetailCard(
                title: _titleDetailDay(_selectedDay),
                log: _logFor(_selectedDay),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  static const _labels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Center(
              child: Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: i == 0
                      ? Colors.red.shade400
                      : i == 6
                      ? Colors.blue.shade400
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.visibleMonth,
    required this.selectedDay,
    required this.today,
    required this.logFor,
    required this.typesWithIntake,
    required this.onSelectDay,
  });

  final DateTime visibleMonth;
  final DateTime selectedDay;
  final DateTime today;
  final WaterLog? Function(DateTime day) logFor;
  final Set<BeverageType> Function(WaterLog? log) typesWithIntake;
  final void Function(DateTime day) onSelectDay;

  int _leadingBlanks(DateTime firstOfMonth) => firstOfMonth.weekday % 7;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final leading = _leadingBlanks(first);
    final totalCells = ((leading + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 4,
        childAspectRatio: 0.72,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNum = index - leading + 1;
        if (dayNum < 1 || dayNum > daysInMonth) {
          return const SizedBox.shrink();
        }
        final day = DateTime(visibleMonth.year, visibleMonth.month, dayNum);
        final log = logFor(day);
        final types = typesWithIntake(log);
        final hasData = types.isNotEmpty;
        final isSelected =
            day.year == selectedDay.year &&
            day.month == selectedDay.month &&
            day.day == selectedDay.day;
        final isToday =
            day.year == today.year && day.month == today.month && day.day == today.day;

        return GestureDetector(
          onTap: () => onSelectDay(day),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.mainBlue.withValues(alpha: 0.22)
                  : hasData
                  ? AppColors.mainBlue.withValues(alpha: 0.08)
                  : null,
              borderRadius: BorderRadius.circular(10),
              border: isToday
                  ? Border.all(color: AppColors.mainBlue, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Column(
              children: [
                Text(
                  '$dayNum',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2,
                    runSpacing: 2,
                    children: [
                      for (final t in BeverageType.values)
                        if (types.contains(t)) _BeverageMiniIcon(type: t),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BeverageMiniIcon extends StatelessWidget {
  const _BeverageMiniIcon({required this.type});

  final BeverageType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: Image.asset(
        type.assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          type.icon,
          size: 16,
          color: type == BeverageType.water ? AppColors.mainBlue : type.color,
        ),
      ),
    );
  }
}

class _DayDetailCard extends StatelessWidget {
  const _DayDetailCard({required this.title, required this.log});

  final String title;
  final WaterLog? log;

  @override
  Widget build(BuildContext context) {
    final entries = <({BeverageType type, int ml})>[];
    if (log != null) {
      for (final t in BeverageType.values) {
        final ml = log!.beverages[t.id] ?? 0;
        if (ml > 0) entries.add((type: t, ml: ml));
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            Text(
              '기록이 없습니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            )
          else
            Column(
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: Image.asset(
                            entries[i].type.assetPath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              entries[i].type.icon,
                              color: entries[i].type.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entries[i].type.label,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Text(
                          '${entries[i].ml}ml',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
