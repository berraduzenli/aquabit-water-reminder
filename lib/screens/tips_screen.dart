import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: AquaBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
            children: const [
              Row(
                children: [
                  Text(
                    'Su İpuçları',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '💧',
                    style: TextStyle(fontSize: 26),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _TipCard(
                emoji: '🌅',
                title: 'Güne Su ile Başla',
                description:
                    'Uyandığınızda içeceğiniz oda sıcaklığındaki bir bardak su, gece boyunca susuz kalan organlarınızı canlandırır ve metabolizmanızı güne hazırlar.',
                color: Color(0xFFE1F3FF),
              ),
              _TipCard(
                emoji: '⏳',
                title: 'Susamayı Bekleme',
                description:
                    'Susuzluk hissi, aslında vücudunuzun nemsiz kalmaya başladığının geç bir sinyalidir. Suyu gün içine yayarak, henüz susamadan içmeyi alışkanlık haline getirin.',
                color: Color(0xFFE9F8EA),
              ),
              _TipCard(
                emoji: '💧',
                title: 'Küçük Yudumlar',
                description:
                    'Bir anda çok miktarda su içmek böbreklerden hızla süzülüp atılmasına neden olur. Suyu zamana yayarak yavaş yavaş içmek, hücrelerin suyu daha verimli emmesini sağlar.',
                color: Color(0xFFFFF6DA),
              ),
              _TipCard(
                emoji: '🍽️',
                title: 'Yemekten Önce İç',
                description:
                    'Yemekten yaklaşık 30-40 dakika önce içilen su, mideyi temizler ve sindirim sistemini yemeğe hazırlar. Yemek sırasında çok su içmek mide asidini seyreltip sindirimi zorlaştırabilir.',
                color: Color(0xFFFFE3ED),
              ),
              _TipCard(
                emoji: '🍋',
                title: 'Doğadan Yardım Al',
                description:
                    'Suyunuzun içine bir dilim limon, taze nane, salatalık veya tarçın ekleyerek içimini daha keyifli hale getirebilirsiniz.',
                color: Color(0xFFF2E7FF),
              ),
              _TipCard(
                emoji: '🌙',
                title: 'Uyumadan Önce Azalt',
                description:
                    'Gece uykunuzun bölünmemesi için yatma saatine yakın su tüketimini azaltabilirsiniz.',
                color: Color(0xFFE8ECFF),
              ),
              _TipCard(
                emoji: '🚰',
                title: 'Doğru Kap Seç',
                description:
                    'Cam, porselen veya paslanmaz çelik kaplar suyun tadını daha iyi korur. Plastik şişeler yerine daha sağlıklı seçenekleri tercih edebilirsiniz.',
                color: Color(0xFFE2F6F4),
              ),
              _TipCard(
                emoji: '🏃‍♀️',
                title: 'Egzersizde Su Dengesi',
                description:
                    'Spordan önce, spor sırasında ve sonrasında küçük yudumlarla su içerek kaybettiğiniz sıvıyı geri kazanın.',
                color: Color(0xFFE1F3FF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  const _TipCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppShadow.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.65),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade800,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
