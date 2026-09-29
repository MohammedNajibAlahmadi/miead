import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/di.dart';
import '../../domain/entities/timer_session.dart';
import '../bloc/focus_cubit.dart';
import '../bloc/focus_state.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FocusCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('جلسة تركيز', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<FocusCubit, FocusState>(
          builder: (context, state) {
            final session = state.session;
            final isRunning = session.state == TimerState.running;
            final isPaused = session.state == TimerState.paused;
            final isCompleted = session.state == TimerState.completed;

            final remaining = session.duration - session.elapsed;
            final minutes = remaining.inMinutes.toString().padLeft(2, '0');
            final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor, 
                                Theme.of(context).primaryColorDark
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$minutes:$seconds',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 80,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  if (session.state == TimerState.idle || session.state == TimerState.prepared) ...[
                    Text('اختر نوع الجلسة:', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(SessionType.study, 'مذاكرة', session, context),
                        _buildChip(SessionType.quran, 'قرآن', session, context),
                        _buildChip(SessionType.reading, 'قراءة', session, context),
                        _buildChip(SessionType.work, 'عمل', session, context),
                        ...state.customTags.map((tag) => _buildCustomChip(tag, session, context)),
                        _buildAddCustomChip(context),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: session.duration.inMinutes > 1 
                              ? () => context.read<FocusCubit>().updateDuration(session.duration.inMinutes - 1) 
                              : null,
                          icon: const Icon(Icons.remove_circle, size: 32),
                          color: Theme.of(context).primaryColor,
                        ),
                        InkWell(
                          onTap: () async {
                            final initialTime = TimeOfDay(
                              hour: session.duration.inMinutes ~/ 60,
                              minute: session.duration.inMinutes % 60,
                            );
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: initialTime,
                              helpText: 'اختر مدة الجلسة (ساعات : دقائق)',
                            );
                            if (selectedTime != null && context.mounted) {
                              final total = (selectedTime.hour * 60) + selectedTime.minute;
                              if (total > 0) context.read<FocusCubit>().updateDuration(total);
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  'المدة: ${session.duration.inMinutes} دقيقة', 
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<FocusCubit>().updateDuration(session.duration.inMinutes + 1),
                          icon: const Icon(Icons.add_circle, size: 32),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    Slider(
                      value: session.duration.inMinutes.toDouble().clamp(1.0, 300.0),
                      min: 1,
                      max: 300,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (val) => context.read<FocusCubit>().updateDuration(val.toInt()),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton.icon(
                      onPressed: () => context.read<FocusCubit>().start(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('بدء الجلسة الآن'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ] else if (isCompleted) ...[
                    const Icon(Icons.check_circle, size: 80, color: Colors.green),
                    const SizedBox(height: 16),
                    Text('ممتاز! لقد أكملت جلستك بنجاح.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () => context.read<FocusCubit>().stop(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('جلسة جديدة'),
                    ),
                  ] else ...[
                     const SizedBox(height: 48),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (isRunning)
                          FloatingActionButton.large(
                            heroTag: 'pause',
                            onPressed: () => context.read<FocusCubit>().pause(),
                            child: const Icon(Icons.pause),
                          )
                        else if (isPaused)
                          FloatingActionButton.large(
                            heroTag: 'play',
                            onPressed: () => context.read<FocusCubit>().resume(),
                            child: const Icon(Icons.play_arrow),
                          ),
                        FloatingActionButton.large(
                          heroTag: 'stop',
                          onPressed: () => context.read<FocusCubit>().stop(),
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red,
                          child: const Icon(Icons.stop),
                        ),
                      ],
                    )
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChip(SessionType type, String label, TimerSession session, BuildContext context) {
    final isSelected = type == session.type && session.type != SessionType.custom;
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 16)),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) context.read<FocusCubit>().selectType(type);
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
      checkmarkColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildCustomChip(String label, TimerSession session, BuildContext context) {
    final isSelected = session.type == SessionType.custom && session.customLabel == label;
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 16)),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) context.read<FocusCubit>().setCustomLabel(label);
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
      checkmarkColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildAddCustomChip(BuildContext context) {
    return ActionChip(
      label: const Text('مخصص +', style: TextStyle(fontSize: 16)),
      onPressed: () async {
        final TextEditingController controller = TextEditingController();
        final String? result = await showDialog<String>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('نوع جلسة جديدة'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: ''),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('إضافة')),
            ],
          ),
        );
        if (result != null && result.trim().isNotEmpty && context.mounted) {
          context.read<FocusCubit>().setCustomLabel(result.trim());
        }
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), style: BorderStyle.solid)),
    );
  }
}
