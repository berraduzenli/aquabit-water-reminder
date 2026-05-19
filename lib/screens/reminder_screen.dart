import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  int _selectedInterval = 60;
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WaterProvider>();
    final progress = provider.progress.clamp(0.0, 1.0);
    final total = provider.todayTotal;
    final goal = provider.dailyGoal;
    final streak = provider.getStreak();
    final logs = provider.todayLogs;
    final remainingMl =
        ((goal - total) > 0 ? ((goal - total) * 1000).round() : 0);

    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: AquaBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  onNotificationTap: () {
                    setState(() => _showSettings = !_showSettings);
                  },
                ),
                const SizedBox(height: 22),
                _HeroReminderCard(
                  total: total,
                  goal: goal,
                  progress: progress,
                  remainingMl: remainingMl,
                ),
                const SizedBox(height: 22),
                const _SectionTitle('Bugün İçtiğin Su'),
                const SizedBox(height: 10),
                _TodayWaterCard(logs: logs),
                const SizedBox(height: 22),
                const _SectionTitle('Hızlı Ekle'),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(
                      child: _QuickAddButton(
                        label: '+150ml',
                        amount: 0.15,
                        icon: Icons.coffee,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickAddButton(
                        label: '+250ml',
                        amount: 0.25,
                        icon: Icons.local_drink,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickAddButton(
                        label: '+500ml',
                        amount: 0.5,
                        icon: Icons.water_drop,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickAddButton(
                        label: '+350ml',
                        amount: 0.35,
                        icon: Icons.local_cafe,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ActionMiniCard(
                        icon: Icons.alarm_rounded,
                        title: 'Hatırlatma Ayarları',
                        subtitle: 'Her $_selectedInterval dakikada bir',
                        color: AppColors.primary,
                        showArrow: true,
                        onTap: () {
                          setState(() => _showSettings = !_showSettings);
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ActionMiniCard(
                        icon: Icons.local_fire_department_rounded,
                        title: '$streak Günlük Seri',
                        subtitle: 'Devam et!',
                        color: AppColors.warning,
                        showArrow: false,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _showSettings
                      ? Padding(
                          key: const ValueKey('settings'),
                          padding: const EdgeInsets.only(top: 18),
                          child: _ReminderSettingsCard(
                            selectedInterval: _selectedInterval,
                            onIntervalSelected: (interval) {
                              setState(() => _selectedInterval = interval);
                              NotificationService.scheduleRepeatingNotification(
                                  interval);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    interval == 30
                                        ? '✅ Hatırlatıcı ayarlandı! (30 dk)'
                                        : interval == 60
                                            ? '✅ Hatırlatıcı ayarlandı! (1 saat)'
                                            : '✅ Hatırlatıcı ayarlandı! (2 saat)',
                                  ),
                                ),
                              );
                            },
                            onCancel: () {
                              NotificationService.cancelAll();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('❌ Hatırlatıcı kapatıldı'),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const _Header({
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Hatırlatıcılar',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
        ),
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.primaryDark,
            size: 27,
          ),
        ),
      ],
    );
  }
}

class _HeroReminderCard extends StatelessWidget {
  final double total;
  final double goal;
  final double progress;
  final int remainingMl;

  const _HeroReminderCard({
    required this.total,
    required this.goal,
    required this.progress,
    required this.remainingMl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF35B8FF),
            Color(0xFF0078E8),
            Color(0xFF0057D9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günlük Hedef',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  '${total.toStringAsFixed(1)}L / ${goal.toStringAsFixed(1)}L',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Kalan $remainingMl ml',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 104,
            height: 104,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 98,
                  height: 98,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 7,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: Colors.white.withOpacity(0.65),
                        size: 28,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayWaterCard extends StatelessWidget {
  final List<dynamic> logs;

  const _TodayWaterCard({
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return AquaCard(
        padding: const EdgeInsets.all(18),
        radius: 24,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.water_drop,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Bugün henüz su kaydı yok. İlk bardağını ekleyerek başla!',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final last = logs.last.timestamp;

    return AquaCard(
      padding: const EdgeInsets.all(18),
      radius: 24,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Son ekleme: ${last.hour.toString().padLeft(2, '0')}:${last.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Toplam ${logs.length} bardak',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: logs.take(9).map<Widget>((log) {
                final isFull = log.amount >= 0.4;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color:
                              isFull ? AppColors.primary : AppColors.softBlue,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          Icons.water_drop,
                          color: isFull ? Colors.white : AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(log.amount * 1000).round()}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;

  const _QuickAddButton({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<WaterProvider>().addWater(amount, 'quick'),
      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadow.card,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.softerBlue,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionMiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool showArrow;
  final VoidCallback onTap;

  const _ActionMiniCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.showArrow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AquaCard(
        padding: const EdgeInsets.all(15),
        radius: 22,
        child: SizedBox(
          height: 82,
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 23,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderSettingsCard extends StatelessWidget {
  final int selectedInterval;
  final ValueChanged<int> onIntervalSelected;
  final VoidCallback onCancel;

  const _ReminderSettingsCard({
    required this.selectedInterval,
    required this.onIntervalSelected,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AquaCard(
      padding: const EdgeInsets.all(18),
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.alarm_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Hatırlatma Ayarları',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Her $selectedInterval dakikada bir hatırlat',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _IntervalOption(
            label: 'Her 30 dakikada bir',
            isSelected: selectedInterval == 30,
            onTap: () => onIntervalSelected(30),
          ),
          _IntervalOption(
            label: 'Her 1 saatte bir',
            isSelected: selectedInterval == 60,
            onTap: () => onIntervalSelected(60),
          ),
          _IntervalOption(
            label: 'Her 2 saatte bir',
            isSelected: selectedInterval == 120,
            onTap: () => onIntervalSelected(120),
          ),
          const SizedBox(height: 8),
          Divider(
            height: 20,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onCancel,
            child: const Row(
              children: [
                Icon(
                  Icons.notifications_off_rounded,
                  color: AppColors.danger,
                  size: 21,
                ),
                SizedBox(width: 10),
                Text(
                  'Hatırlatıcıyı kapat',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IntervalOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _IntervalOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softBlue : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color:
                      isSelected ? AppColors.primaryDark : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w900,
        color: AppColors.primaryDark,
      ),
    );
  }
}
