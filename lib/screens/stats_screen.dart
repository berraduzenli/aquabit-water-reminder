import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/water_provider.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WaterProvider>();
    final rawWeeklyData = provider.getWeeklyData();
    final weeklyData = List<double>.generate(
      7,
      (index) => index < rawWeeklyData.length ? rawWeeklyData[index] : 0.0,
    );

    final goal = provider.dailyGoal;
    final total = weeklyData.fold<double>(0.0, (sum, value) => sum + value);
    final average = total / 7;
    final bestValue = weeklyData.reduce((a, b) => a > b ? a : b);
    final bestIndex = weeklyData.indexOf(bestValue);

    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final bestDay = bestValue > 0 ? days[bestIndex] : '-';

    final maxChartY = _calculateMaxY(goal, weeklyData);

    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: AquaBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'İstatistik',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 18),
                _SegmentedTabs(
                  onMonthlyTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Aylık istatistik yakında eklenecek 📅'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onYearlyTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Yıllık istatistik yakında eklenecek 📊'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                AquaCard(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  radius: 26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Haftalık Su Tüketimi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softerBlue,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Text(
                              'Litre',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '${total.toStringAsFixed(1)} L',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryDark,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Bu Hafta Toplam',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 205,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxChartY,
                            minY: 0,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipRoundedRadius: 12,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  final value = weeklyData[group.x.toInt()];
                                  return BarTooltipItem(
                                    '${days[group.x.toInt()]}\n${value.toStringAsFixed(1)} L',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index < 0 || index >= days.length) {
                                      return const SizedBox.shrink();
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        days[index],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: index == 6
                                              ? AppColors.primary
                                              : Colors.grey.shade500,
                                          fontWeight: index == 6
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 34,
                                  interval: 0.5,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 0.5 != 0) {
                                      return const SizedBox.shrink();
                                    }

                                    return Text(
                                      '${value.toStringAsFixed(1)}L',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 0.5,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: const Color(0xFFE6EAF0),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(7, (i) {
                              final value = weeklyData[i];
                              final hasData = value > 0;
                              final isToday = i == 6;

                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: hasData ? value : 0.08,
                                    width: 21,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    gradient: hasData
                                        ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: value >= goal
                                                ? [
                                                    const Color(0xFF63C96B),
                                                    const Color(0xFF43B653),
                                                  ]
                                                : isToday
                                                    ? [
                                                        const Color(0xFF5EBBFF),
                                                        AppColors.primary,
                                                      ]
                                                    : [
                                                        const Color(0xFFDDEAF7),
                                                        const Color(0xFFEAF3FC),
                                                      ],
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xFFEAF1F8),
                                              Color(0xFFF2F7FC),
                                            ],
                                          ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _SmallStatCard(
                        icon: Icons.water_drop,
                        iconColor: AppColors.primary,
                        iconBackground: AppColors.softBlue,
                        title: 'Günlük Ortalama',
                        value: '${average.toStringAsFixed(1)} L',
                        valueColor: AppColors.primaryDark,
                        subtitle: goal > 0
                            ? '%${((average / goal) * 100).round()} hedefe göre'
                            : 'Hedef bilgisi yok',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _SmallStatCard(
                        icon: Icons.show_chart_rounded,
                        iconColor: AppColors.success,
                        iconBackground: const Color(0xFFE8F8EC),
                        title: 'En İyi Gün',
                        value: '${bestValue.toStringAsFixed(1)} L',
                        valueColor: AppColors.warning,
                        subtitle: bestDay,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AquaCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  radius: 20,
                  color: const Color(0xFFEAF6FF),
                  boxShadow: AppShadow.soft,
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.water_drop,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          total >= goal * 7
                              ? 'Bu hafta hedefini tamamladın! Harika gidiyorsun 🎉'
                              : 'Bu hafta toplam ${total.toStringAsFixed(1)} L su içtin. Devam et!',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static double _calculateMaxY(double goal, List<double> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final candidate = [
      3.0,
      goal * 1.5,
      maxValue + 0.5,
    ].reduce((a, b) => a > b ? a : b);

    return candidate.ceilToDouble();
  }
}

class _SegmentedTabs extends StatelessWidget {
  final VoidCallback onMonthlyTap;
  final VoidCallback onYearlyTap;

  const _SegmentedTabs({
    required this.onMonthlyTap,
    required this.onYearlyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadow.soft,
      ),
      child: Row(
        children: [
          const Expanded(
            child: _SegmentItem(
              title: 'Haftalık',
              selected: true,
            ),
          ),
          Expanded(
            child: _SegmentItem(
              title: 'Aylık',
              selected: false,
              onTap: onMonthlyTap,
            ),
          ),
          Expanded(
            child: _SegmentItem(
              title: 'Yıllık',
              selected: false,
              onTap: onYearlyTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const _SegmentItem({
    required this.title,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: selected
            ? const LinearGradient(
                colors: [
                  Color(0xFF2FAAF7),
                  Color(0xFF0078E8),
                ],
              )
            : null,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );

    if (onTap == null) return child;

    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;

  const _SmallStatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return AquaCard(
      padding: const EdgeInsets.all(16),
      radius: 22,
      child: SizedBox(
        height: 116,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: valueColor,
                height: 1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
