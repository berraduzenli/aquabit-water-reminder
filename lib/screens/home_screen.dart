import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/water_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WaterProvider>();
    final progress = provider.progress.clamp(0.0, 1.0);
    final total = provider.todayTotal;
    final goal = provider.dailyGoal;
    final streak = provider.getStreak();
    final remaining =
        ((goal - total) > 0 ? (goal - total) : 0).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.water_drop,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'AquaBit',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
                fontSize: 21,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryDark,
            ),
            onPressed: () => _showNotificationDialog(context),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.primaryDark,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AquaBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GoalCard(
                progress: progress,
                total: total,
                goal: goal,
                remaining: remaining,
                waveController: _waveController,
                goalReached: provider.goalReached,
              ),
              const SizedBox(height: 22),
              const _SectionTitle('Hızlı Ekle'),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _QuickBtn(
                      label: '+150ml',
                      amount: 0.15,
                      icon: Icons.coffee,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _QuickBtn(
                      label: '+250ml',
                      amount: 0.25,
                      icon: Icons.local_drink,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _QuickBtn(
                      label: '+500ml',
                      amount: 0.5,
                      icon: Icons.water_drop,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _QuickBtn(
                      label: '+350ml',
                      amount: 0.35,
                      icon: Icons.local_cafe,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AquaPrimaryButton(
                text: 'Özel Miktar Ekle',
                icon: Icons.water_drop,
                onTap: () => _showCustomAmountDialog(context),
              ),
              const SizedBox(height: 18),
              _StreakCard(streak: streak),
              const SizedBox(height: 20),
              if (provider.todayLogs.isNotEmpty) ...[
                const _SectionTitle('Bugün İçtiğin Su'),
                const SizedBox(height: 10),
                _TodayWaterCard(provider: provider),
                const SizedBox(height: 18),
              ],
              if (provider.todayLogs.isNotEmpty)
                Center(
                  child: TextButton.icon(
                    onPressed: () =>
                        context.read<WaterProvider>().removeLastLog(),
                    icon: const Icon(
                      Icons.undo,
                      color: AppColors.danger,
                      size: 18,
                    ),
                    label: const Text(
                      'Son kaydı geri al',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: const Row(
          children: [
            Icon(Icons.notifications, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Hatırlatıcı Ayarla',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NotifTile(
              label: 'Her 30 dakikada bir',
              onTap: () {
                NotificationService.scheduleRepeatingNotification(30);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Hatırlatıcı ayarlandı! (30 dk)'),
                  ),
                );
              },
            ),
            _NotifTile(
              label: 'Her 1 saatte bir',
              onTap: () {
                NotificationService.scheduleRepeatingNotification(60);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Hatırlatıcı ayarlandı! (1 saat)'),
                  ),
                );
              },
            ),
            _NotifTile(
              label: 'Her 2 saatte bir',
              onTap: () {
                NotificationService.scheduleRepeatingNotification(120);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Hatırlatıcı ayarlandı! (2 saat)'),
                  ),
                );
              },
            ),
            _NotifTile(
              label: 'Hatırlatıcıyı kapat',
              isRed: true,
              onTap: () {
                NotificationService.cancelAll();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Hatırlatıcı kapatıldı'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomAmountDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: const Text(
          'Özel Miktar Ekle',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Miktar (ml)',
            prefixIcon: const Icon(
              Icons.water_drop,
              color: AppColors.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                context.read<WaterProvider>().addWater(amount / 1000, 'custom');
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final double progress;
  final double total;
  final double goal;
  final String remaining;
  final AnimationController waveController;
  final bool goalReached;

  const _GoalCard({
    required this.progress,
    required this.total,
    required this.goal,
    required this.remaining,
    required this.waveController,
    required this.goalReached,
  });

  @override
  Widget build(BuildContext context) {
    return AquaCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
      radius: 28,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Merhaba! 💙',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Sağlıklı bir gün için su içmeyi unutma.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${total.toStringAsFixed(1)}L',
                        style: const TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '/ ${goal.toStringAsFixed(1)}L',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Kalan $remaining L',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEAF6FF),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.14),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: CircleWaterPainter(
                    progress: progress,
                    wavePhase: waveController.value * 2 * math.pi,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: progress > 0.45
                            ? Colors.white.withOpacity(0.12)
                            : Colors.white.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: progress > 0.45
                                  ? Colors.white
                                  : AppColors.primary,
                              shadows: progress > 0.45
                                  ? [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.12),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                          if (goalReached) ...[
                            const SizedBox(height: 4),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.primaryDark,
      ),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;

  const _QuickBtn({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<WaterProvider>().addWater(amount, 'quick'),
      child: Container(
        height: 92,
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
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;

  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return AquaCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      radius: 24,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text(
                '🔥',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak Günlük Seri',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Harika gidiyorsun! Devam et!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
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
  final WaterProvider provider;

  const _TodayWaterCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final last = provider.todayLogs.last.timestamp;

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
                'Toplam ${provider.todayLogs.length} bardak',
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
              children: provider.todayLogs
                  .take(9)
                  .map(
                    (log) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: log.amount >= 0.4
                                  ? AppColors.primary
                                  : AppColors.softBlue,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              Icons.water_drop,
                              color: log.amount >= 0.4
                                  ? Colors.white
                                  : AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${(log.amount * 1000).toInt()}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isRed;

  const _NotifTile({
    required this.label,
    required this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TextStyle(
          color: isRed ? AppColors.danger : AppColors.primaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: isRed ? AppColors.danger : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

class CircleWaterPainter extends CustomPainter {
  final double progress;
  final double wavePhase;

  CircleWaterPainter({
    required this.progress,
    required this.wavePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final bgPaint = Paint()
      ..color = AppColors.softBlue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final waterHeight = size.height * progress;
      final waterTop = size.height - waterHeight;

      final path = Path();
      path.moveTo(0, size.height);
      path.lineTo(0, waterTop + 10);

      for (double x = 0; x <= size.width; x++) {
        final y =
            waterTop + math.sin((x / size.width * 2 * math.pi) + wavePhase) * 7;
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.close();

      final waterPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF63C9FF),
            Color(0xFF2196F3),
            Color(0xFF0A7FE8),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      );
      canvas.drawPath(path, waterPaint);

      final shinePaint = Paint()
        ..color = Colors.white.withOpacity(0.18)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width * 0.36, size.height * 0.28),
        4,
        shinePaint,
      );
      canvas.drawCircle(
        Offset(size.width * 0.55, size.height * 0.24),
        5,
        shinePaint,
      );

      canvas.restore();
    }

    final outerBorderPaint = Paint()
      ..color = const Color(0xFFD8EEFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawCircle(center, radius + 2, outerBorderPaint);

    final progressPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: math.pi * 1.5,
        colors: [
          Color(0xFF4FC3FF),
          Color(0xFF2196F3),
          Color(0xFF0078E8),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 2),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );

    final innerBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 1, innerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CircleWaterPainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase ||
        oldDelegate.progress != progress;
  }
}
