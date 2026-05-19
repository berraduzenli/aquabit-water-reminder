import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loaded = false;

  double _weight = 60;
  double _dailyGoal = 2.1;
  String _gender = 'female';
  int _wakeHour = 8;
  int _sleepHour = 23;
  int _selectedInterval = 60;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;

    final user = context.read<WaterProvider>().user;

    if (user != null) {
      _weight = user.weight;
      _dailyGoal = user.dailyGoal;
      _gender = user.gender;
      _wakeHour = user.wakeHour;
      _sleepHour = user.sleepHour;
    }

    _loaded = true;
  }

  Future<void> _saveSettings() async {
    await context.read<WaterProvider>().updateUserSettings(
          weight: _weight,
          gender: _gender,
          wakeHour: _wakeHour,
          sleepHour: _sleepHour,
          customDailyGoal: _dailyGoal,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Ayarlar kaydedildi'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: AquaBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(onBack: () => Navigator.pop(context)),
                const SizedBox(height: 22),
                AquaCard(
                  radius: 26,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CardTitle(
                        icon: Icons.person_rounded,
                        title: 'Kişisel Bilgiler',
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _GenderOption(
                              title: 'Erkek',
                              icon: Icons.man_rounded,
                              selected: _gender == 'male',
                              onTap: () => setState(() => _gender = 'male'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GenderOption(
                              title: 'Kadın',
                              icon: Icons.woman_rounded,
                              selected: _gender == 'female',
                              onTap: () => setState(() => _gender = 'female'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _ValueHeader(
                        title: 'Kilon',
                        value: '${_weight.toInt()} kg',
                      ),
                      SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: _weight,
                          min: 30,
                          max: 150,
                          divisions: 120,
                          onChanged: (value) {
                            setState(() => _weight = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AquaCard(
                  radius: 26,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CardTitle(
                        icon: Icons.water_drop_rounded,
                        title: 'Günlük Hedef',
                      ),
                      const SizedBox(height: 18),
                      _ValueHeader(
                        title: 'Hedef miktarın',
                        value: '${_dailyGoal.toStringAsFixed(1)} L',
                      ),
                      SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: _dailyGoal,
                          min: 1.0,
                          max: 5.0,
                          divisions: 40,
                          onChanged: (value) {
                            setState(() => _dailyGoal = value);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.softerBlue,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Bu hedef ana ekranda ve istatistiklerde kullanılacak.',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AquaCard(
                  radius: 26,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CardTitle(
                        icon: Icons.schedule_rounded,
                        title: 'Günlük Saatler',
                      ),
                      const SizedBox(height: 18),
                      _ValueHeader(
                        title: 'Uyanma saatin',
                        value: '${_wakeHour.toString().padLeft(2, '0')}:00',
                      ),
                      SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: _wakeHour.toDouble(),
                          min: 0,
                          max: 23,
                          divisions: 23,
                          onChanged: (value) {
                            setState(() => _wakeHour = value.toInt());
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ValueHeader(
                        title: 'Uyku saatin',
                        value: '${_sleepHour.toString().padLeft(2, '0')}:00',
                      ),
                      SliderTheme(
                        data: _sliderTheme(context),
                        child: Slider(
                          value: _sleepHour.toDouble(),
                          min: 0,
                          max: 23,
                          divisions: 23,
                          onChanged: (value) {
                            setState(() => _sleepHour = value.toInt());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AquaCard(
                  radius: 26,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CardTitle(
                        icon: Icons.notifications_active_rounded,
                        title: 'Bildirim Aralığı',
                      ),
                      const SizedBox(height: 16),
                      _IntervalOption(
                        title: 'Her 30 dakikada bir',
                        selected: _selectedInterval == 30,
                        onTap: () {
                          setState(() => _selectedInterval = 30);
                          NotificationService.scheduleRepeatingNotification(30);
                        },
                      ),
                      _IntervalOption(
                        title: 'Her 1 saatte bir',
                        selected: _selectedInterval == 60,
                        onTap: () {
                          setState(() => _selectedInterval = 60);
                          NotificationService.scheduleRepeatingNotification(60);
                        },
                      ),
                      _IntervalOption(
                        title: 'Her 2 saatte bir',
                        selected: _selectedInterval == 120,
                        onTap: () {
                          setState(() => _selectedInterval = 120);
                          NotificationService.scheduleRepeatingNotification(
                              120);
                        },
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          NotificationService.cancelAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Hatırlatıcı kapatıldı'),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.notifications_off_rounded,
                              color: AppColors.danger,
                              size: 22,
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
                ),
                const SizedBox(height: 24),
                AquaPrimaryButton(
                  text: 'Ayarları Kaydet',
                  icon: Icons.check_rounded,
                  onTap: _saveSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliderThemeData _sliderTheme(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.softBlue,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.18),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: AppShadow.soft,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryDark,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'Ayarlar',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CardTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.softBlue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ValueHeader extends StatelessWidget {
  final String title;
  final String value;

  const _ValueHeader({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 88,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF2FAAF7),
                    Color(0xFF0078E8),
                  ],
                )
              : null,
          color: selected ? null : AppColors.softerBlue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.softBlue,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AppColors.primary,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.primaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntervalOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _IntervalOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: selected ? AppColors.softBlue : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color:
                      selected ? AppColors.primaryDark : Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
