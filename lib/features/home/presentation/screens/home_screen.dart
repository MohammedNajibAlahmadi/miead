import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/dependency_injection/di.dart';
import '../../../prayer/presentation/widgets/prayer_card.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../../../../features/khatma/domain/entities/khatma_progress.dart';
import '../../../../features/khatma/presentation/bloc/khatma_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مِيعاد', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading || state.status == HomeStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == HomeStatus.failure) {
              return const Center(child: Text('حدث خطأ في تحميل البيانات'));
            }

            return Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Opacity(
                      opacity: 0.05, // Subtle watermark effect
                      child: Image.asset('assets/images/logo.png', width: 350, height: 350, fit: BoxFit.contain),
                    ),
                  ),
                ),
                ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'صباح الخير، اليوم ${state.dateString}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _DailyInspirationBanner(inspiration: state.dynamicInspiration ?? '﴿وَقُلِ اعمَلوا فَسَيَرَى اللَّهُ عَمَلَكُم﴾'),
                if (state.isFriday) ...[
                  const SizedBox(height: 16),
                  GestureDetector(
                     onTap: () => GoRouter.of(context).push('/friday'),
                     child: Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(16),
                         gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFC2B280)]),
                       ),
                       child: Row(
                         children: [
                           const Icon(Icons.mosque, color: Colors.white),
                           const SizedBox(width: 12),
                           const Expanded(child: Text('يوم الجمعة: استكشف تراث وروحانية اليوم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                           const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                         ],
                       ),
                     ),
                  ),
                ],
                const SizedBox(height: 24),
                PrayerCard(
                  prayerName: state.nextPrayerName ?? 'غير معروف',
                  prayerTime: state.nextPrayerTime ?? '--:--',
                ),
                const SizedBox(height: 24),
                BlocProvider(
                  create: (_) => getIt<KhatmaCubit>(),
                  child: BlocBuilder<KhatmaCubit, KhatmaProgress>(
                    builder: (context, khatma) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ورد القرآن (الختمة)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  Text('${khatma.percentage.toStringAsFixed(1)}%', style: const TextStyle(color: Color(0xFF006A4E), fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: khatma.currentPage / 604,
                                backgroundColor: Colors.grey.shade200,
                                color: const Color(0xFFD4AF37),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('سورة ${khatma.surahName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text('الصفحة ${khatma.currentPage} من 604', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF006A4E)),
                                        onPressed: () => context.read<KhatmaCubit>().addPages(-1),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle, color: Color(0xFF006A4E), size: 36),
                                        onPressed: () => context.read<KhatmaCubit>().addPages(1),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'النشاط الحالي',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
                    ),
                    boxShadow: [
                      BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    title: Text(state.currentActivity ?? 'لا يوجد نشاط حالي', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(
                      state.currentActivity == null ? 'خذ قسطاً من الراحة أو ابدأ تحدياً جديداً..' : 'جاري التنفيذ والتسجيل بكل همة...',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    leading: const Icon(Icons.bolt_rounded, color: Colors.amber, size: 36),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مهام اليوم', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    if (state.tasks.isNotEmpty)
                      Text('${state.tasks.where((t) => t.isCompleted).length} / ${state.tasks.length} منجزة', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                if (state.tasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        const Text('أنجزت جميع مهامك ببراعة!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                         const SizedBox(height: 8),
                        const Text('اضغط على الزر (+) لإضافة مهام أو عادات جديدة ليومك.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                else
                  ...state.tasks.map((task) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: task.isCompleted ? Colors.transparent : Colors.grey.withValues(alpha: 0.2)),
                    ),
                    color: task.isCompleted ? Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.4) : Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CheckboxListTile(
                         activeColor: Theme.of(context).primaryColor,
                         title: Text(
                           task.title,
                           style: TextStyle(
                              fontSize: 16,
                              fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.bold,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted ? Colors.grey : null,
                           )
                         ),
                         value: task.isCompleted,
                         onChanged: (_) => context.read<HomeCubit>().toggleTask(task),
                      ),
                    ),
                  )),
                ],
              ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showAddTaskBottomSheet(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('أضف إلى يومي'),
        ),
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إضافة نشاط', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'اكتب مهمة يومية جديدة...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: const Icon(Icons.add_task),
                ),
                onSubmitted: (value) {
                  context.read<HomeCubit>().addTask(value);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
              const Divider(),
              ListTile(leading: const Icon(Icons.menu_book), title: const Text('جلسة مذاكرة'), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.menu_book_outlined), title: const Text('جلسة قرآن'), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.autorenew_outlined), title: const Text('جلسة أذكار واستغفار'), onTap: () {
                Navigator.pop(context);
                GoRouter.of(context).push('/adhkar');
              }),
              ListTile(leading: const Icon(Icons.alarm_add), title: const Text('تذكير أو منبه سريع'), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.edit_note, color: Color(0xFFD4AF37)), title: const Text('تدوين تأملات وملاحظات', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)), onTap: () {
                Navigator.pop(context);
                GoRouter.of(context).push('/notes');
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _DailyInspirationBanner extends StatelessWidget {
  final String inspiration;

  const _DailyInspirationBanner({required this.inspiration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, size: 40, color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('إلهام اليوم', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  inspiration,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
