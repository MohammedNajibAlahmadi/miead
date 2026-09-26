import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/di.dart';
import '../bloc/alarms_cubit.dart';
import '../bloc/alarms_state.dart';

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AlarmsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المنبهات', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<AlarmsCubit, AlarmsState>(
          builder: (context, state) {
            if (state.alarms.isEmpty) {
              return const Center(child: Text('لا توجد منبهات مسجلة بعد.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.alarms.length,
              itemBuilder: (context, index) {
                final alarm = state.alarms[index];
                final isActive = alarm.isActive;
                return Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(isActive ? 1.0 : 0.5),
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isActive ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.transparent,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alarm.time.format(use24Hour: false),
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? null : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                alarm.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                   color: isActive ? null : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.autorenew_rounded, size: 18, color: isActive ? Theme.of(context).primaryColor : Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(alarm.activeDays.length == 7 ? 'يومياً' : 'مخصص', style: TextStyle(color: isActive ? null : Colors.grey)),
                                  
                                  const SizedBox(width: 16),
                                  if (alarm.vibration)
                                    Icon(Icons.vibration_rounded, size: 18, color: isActive ? Theme.of(context).primaryColor : Colors.grey),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            value: isActive,
                            onChanged: (_) {
                              context.read<AlarmsCubit>().toggleAlarm(alarm.id);
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_alarm_rounded),
        ),
      ),
    );
  }
}
