import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';

const Color kPrimaryBlue = Color(0xFF2196F3);
const Color kDeepBlue = Color(0xFF0D47A1);
const Color kSoftBlue = Color(0xFFEAF6FF);
const Color kLightBlue = Color(0xFFE3F2FD);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _gender = 'female';
  double _weight = 60;
  int _wakeHour = 8;
  int _sleepHour = 23;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await context.read<WaterProvider>().saveUser(
          weight: _weight,
          gender: _gender,
          wakeHour: _wakeHour,
          sleepHour: _sleepHour,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kPrimaryBlue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryBlue.withOpacity(0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.water_drop,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                const Text('AquaBit',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: kDeepBlue,
                        letterSpacing: 0.2)),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _currentPage ? kPrimaryBlue : kLightBlue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _GenderPage(
                    selected: _gender,
                    onSelect: (g) => setState(() => _gender = g),
                  ),
                  _WeightPage(
                    weight: _weight,
                    gender: _gender,
                    onChanged: (w) => setState(() => _weight = w),
                  ),
                  _TimePage(
                    title: 'Uyanma Saatin',
                    subtitle: 'Hatırlatıcıların bu saate göre ayarlanır.',
                    isNight: false,
                    hour: _wakeHour,
                    onChanged: (h) => setState(() => _wakeHour = h),
                  ),
                  _TimePage(
                    title: 'Uyku Saatin',
                    subtitle: 'Hatırlatıcıların bu saate göre ayarlanır.',
                    isNight: true,
                    hour: _sleepHour,
                    onChanged: (h) => setState(() => _sleepHour = h),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
              child: GestureDetector(
                onTap: _nextPage,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2FAAF7), Color(0xFF0078E8)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryBlue.withOpacity(0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _currentPage == 3 ? 'Başla! 💧' : 'Devam',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderPage extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const _GenderPage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text('Cinsiyetini Seç',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: kDeepBlue)),
          const SizedBox(height: 8),
          const Text('Su ihtiyacın sana özel hesaplanır.',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  label: 'Erkek',
                  isSelected: selected == 'male',
                  isMale: true,
                  onTap: () => onSelect('male'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _GenderCard(
                  label: 'Kadın',
                  isSelected: selected == 'female',
                  isMale: false,
                  onTap: () => onSelect('female'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isMale;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.isSelected,
    required this.isMale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 200,
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? kPrimaryBlue : kLightBlue,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? kPrimaryBlue.withOpacity(0.25)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isSelected)
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(Icons.check_circle, color: Colors.white, size: 22),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    isMale
                        ? 'assets/images/male_avatar.png'
                        : 'assets/images/female_avatar.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      isMale ? Icons.person : Icons.person_2,
                      size: 60,
                      color: isSelected ? Colors.white : kPrimaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : kDeepBlue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightPage extends StatelessWidget {
  final double weight;
  final String gender;
  final Function(double) onChanged;

  const _WeightPage({
    required this.weight,
    required this.gender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final goal = weight * (gender == 'male' ? 40 : 35) / 1000;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text('Kilonu Gir',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: kDeepBlue)),
          const SizedBox(height: 8),
          const Text('Günlük su hedefin kilona göre hesaplanır.',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 48),
          Text('${weight.toInt()} kg',
              style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryBlue)),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: kPrimaryBlue,
              inactiveTrackColor: kLightBlue,
              thumbColor: kPrimaryBlue,
              overlayColor: kPrimaryBlue.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: weight,
              min: 30,
              max: 150,
              divisions: 120,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: kLightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.water_drop, color: kPrimaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Günlük hedefin: ${goal.toStringAsFixed(1)} L',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kDeepBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isNight;
  final int hour;
  final Function(int) onChanged;

  const _TimePage({
    required this.title,
    required this.subtitle,
    required this.isNight,
    required this.hour,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(title,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: kDeepBlue)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 32),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: isNight
                    ? [const Color(0xFF063B8E), const Color(0xFF0E6CD8)]
                    : [
                        const Color(0xFFFFD7D7),
                        const Color(0xFFFFF1B8),
                        const Color(0xFFCDEEFF),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isNight
                      ? const Color(0xFF0D47A1).withOpacity(0.18)
                      : const Color(0xFFFFB74D).withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: isNight
                  ? Image.asset(
                      'assets/images/moon.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          const Text('🌙', style: TextStyle(fontSize: 64)),
                    )
                  : Image.asset(
                      'assets/images/sunrise.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          const Text('🌅', style: TextStyle(fontSize: 64)),
                    ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '${hour.toString().padLeft(2, '0')}:00',
            style: const TextStyle(
                fontSize: 64, fontWeight: FontWeight.bold, color: kPrimaryBlue),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: kPrimaryBlue,
              inactiveTrackColor: kLightBlue,
              thumbColor: kPrimaryBlue,
              overlayColor: kPrimaryBlue.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: hour.toDouble(),
              min: 0,
              max: 23,
              divisions: 23,
              onChanged: (v) => onChanged(v.toInt()),
            ),
          ),
        ],
      ),
    );
  }
}
