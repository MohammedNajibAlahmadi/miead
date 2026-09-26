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
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: [
              _buildPage(
                context,
                icon: Icons.mosque,
                title: 'مرحباً بك في مِيعاد',
                description: 'رفيقك اليومي لإدارة الوقت، العبادات، والمهام الشخصية بكل سهولة.',
              ),
              _buildPage(
                context,
                icon: Icons.wifi_off,
                title: 'آمن ومحلي بصورة تامة',
                description: 'بياناتك محفوظة في جهازك فقط. التطبيق لا يحتاج وتيرة الإنترنت ليعمل أبداً (Offline First).',
              ),
              _buildPage(
                context,
                icon: Icons.timer,
                title: 'تحكم في يومك',
                description: 'استخدم جلسات التركيز، ونظّم مهامك، وحافظ على وردك اليومي للوصول للإنتاجية العالية.',
                isLast: true,
              ),
            ],
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
                      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006A4E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(_currentIndex == 2 ? 'ابدأ الآن' : 'التالي'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, {required IconData icon, required String title, required String description, bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: const Color(0xFF006A4E)),
          const SizedBox(height: 32),
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF006A4E))),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
