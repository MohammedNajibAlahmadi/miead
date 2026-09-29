import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../settings/presentation/bloc/settings_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: [
                _buildIntroPage(context),
                _buildPrayerPage(context),
                _buildAncestorsPage(context),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 6),
                      height: 10,
                      width: _currentIndex == index ? 24 : 10,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? const Color(0xFFD4AF37) : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == 2) {
                      context.read<SettingsCubit>().completeFirstRun();
                      context.go('/');
                    } else {
                      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006A4E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: _currentIndex == 2 ? 8 : 2,
                  ),
                  child: Text(
                    _currentIndex == 2 ? 'بسم الله نبدأ' : 'التالي',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIntroPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png', width: 140, height: 140),
          const SizedBox(height: 32),
          Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006A4E),
              fontFamily: 'Amiri', // assuming this elegant font exists standardly or falls back
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'أهلاً ومرحباً بك في تطبيق (مِيعاد)، رفيقك الرقمي ومساعدك الشخصي في تنظيم يومك، وترتيب وقتك، والحفاظ على عباداتك ومهامك.\n\n﴿وَقُلِ اعمَلوا فَسَيَرَى اللَّهُ عَمَلَكُم﴾',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.8, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 80, color: Color(0xFFD4AF37)),
          const SizedBox(height: 32),
          Text(
            'طلب قبل البدء',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006A4E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'هذا التطبيق صُنع حباً ورغبةً في نشر الخير والأثر الطيب. نسألك بظهر الغيب دعوة صادقة لمن أسس وطور هذا التطبيق.\n\nادعُ له بالتوفيق، والسداد، والنجاح الدائم في دينه ودنياه، وأن يبارك الله في خطاه ويفتح له أبواب فضله ورزقه.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.8, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildAncestorsPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_rounded, size: 80, color: Color(0xFFD4AF37)),
          const SizedBox(height: 32),
          Text(
            'لمسة وفاء ومغفرة',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006A4E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'وفي هذا المقام، نرجو منك إهداء دعوة صالحة بالرحمة الواسعة والمغفرة التامة لأجداد مطور هذا التطبيق، ولمن أسسه ورباه.\n\nاللهم اجعل قبور أجدادنا روضة من رياض الجنة، واجمعنا بهم مع النبيين والصديقين والشهداء والصالحين.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.8, color: Colors.black87),
          ),
          const SizedBox(height: 32),
          const Text(
            '«وَالَّذِينَ جَاءُوا مِن بَعْدِهِمْ يَقُولُونَ رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالْإِيمَانِ»',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.8, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

