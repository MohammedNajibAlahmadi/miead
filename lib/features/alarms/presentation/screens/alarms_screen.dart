import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/datetime/time_engine.dart';
import '../../domain/entities/alarm.dart';
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
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: isActive ? 1.0 : 0.5),
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isActive ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : Colors.transparent,
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
                              InkWell(
                                onTap: () {
                                  _showAlarmEditorBottomSheet(context, existingAlarm: alarm);
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.edit_calendar, size: 28, color: isActive ? Theme.of(context).primaryColor : Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        alarm.time.format(use24Hour: false),
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isActive ? null : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
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
                            activeThumbColor: Theme.of(context).primaryColor,
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
          onPressed: () {
            _showAlarmEditorBottomSheet(context);
          },
          child: const Icon(Icons.add_alarm_rounded),
        ),
      ),
    );
  }

  void _showAlarmEditorBottomSheet(BuildContext context, {AlarmDefinition? existingAlarm}) {
    final isNew = existingAlarm == null;
    TimeOfDay selectedTime = isNew ? TimeOfDay.now() : TimeOfDay(hour: existingAlarm.time.hour, minute: existingAlarm.time.minute);
    final titleCtrl = TextEditingController(text: existingAlarm?.title ?? '');
    bool isVibrationEnabled = existingAlarm?.vibration ?? true;
    String selectedSound = existingAlarm?.soundPath ?? 'default';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                left: 24, right: 24, top: 24
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(isNew ? 'إضافة منبه' : 'تعديل المنبه', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                       IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(sheetContext)),
                     ],
                   ),
                   const SizedBox(height: 24),
                   InkWell(
                     onTap: () async {
                       final t = await showTimePicker(context: context, initialTime: selectedTime, helpText: 'اكتب أو اختر وقت المنبه');
                       if (t != null) setState(() => selectedTime = t);
                     },
                     borderRadius: BorderRadius.circular(16),
                     child: Padding(
                       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                       child: Text(
                         selectedTime.format(context), 
                         style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                       ),
                     ),
                   ),
                   const SizedBox(height: 24),
                   TextField(
                     controller: titleCtrl,
                     decoration: InputDecoration(
                       labelText: 'اسم المنبه (اختياري)',
                       prefixIcon: const Icon(Icons.label_outline),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                   ),
                   const SizedBox(height: 16),
                   SwitchListTile(
                     title: const Text('الاهتزاز (Vibration)', style: TextStyle(fontWeight: FontWeight.bold)),
                     secondary: const Icon(Icons.vibration),
                     value: isVibrationEnabled,
                     activeColor: Theme.of(context).primaryColor,
                     onChanged: (val) => setState(() => isVibrationEnabled = val),
                   ),
                   ListTile(
                     leading: const Icon(Icons.music_note),
                     title: const Text('نغمة التنبيه', style: TextStyle(fontWeight: FontWeight.bold)),
                     subtitle: Text(selectedSound == 'default' ? 'النغمة الافتراضية' : (selectedSound == 'device' ? 'رنين من الجهاز' : selectedSound)),
                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                     onTap: () {
                        showDialog(context: context, builder: (dialogContext) => AlertDialog(
                          title: const Text('اختر نغمة التنبيه'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(title: const Text('النغمة الافتراضية'), onTap: () { setState((){selectedSound = 'default';}); Navigator.pop(dialogContext);}),
                              ListTile(title: const Text('صوت العصافير والطبيعة'), onTap: () { setState((){selectedSound = 'birds';}); Navigator.pop(dialogContext);}),
                              ListTile(title: const Text('أذان الفجر (مكة)'), onTap: () { setState((){selectedSound = 'azan_makkah';}); Navigator.pop(dialogContext);}),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.folder_open),
                                title: const Text('إضافة من الجهاز (ملف صوتي)'), 
                                onTap: () {
                                  setState((){selectedSound = 'device';});
                                  Navigator.pop(dialogContext);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم تفعيل استيراد الملفات الصوتية في النسخة النهائية المجمّعة (APK).')));
                                }
                              ),
                            ],
                          ),
                        ));
                     },
                   ),
                   const SizedBox(height: 24),
                   SizedBox(
                     width: double.infinity,
                     height: 50,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
                       onPressed: () {
                          final newAlarm = AlarmDefinition(
                            id: isNew ? DateTime.now().millisecondsSinceEpoch.toString() : existingAlarm.id,
                            title: titleCtrl.text.isEmpty ? 'تنبيه' : titleCtrl.text,
                            time: LocalTime(selectedTime.hour, selectedTime.minute, 0),
                            isActive: true,
                            activeDays: existingAlarm?.activeDays ?? const [1, 2, 3, 4, 5, 6, 7],
                            vibration: isVibrationEnabled,
                            soundPath: selectedSound,
                          );
                          if (isNew) {
                            context.read<AlarmsCubit>().addAlarm(newAlarm);
                          } else {
                            context.read<AlarmsCubit>().updateFullAlarm(newAlarm);
                          }
                          Navigator.pop(sheetContext);
                       },
                       child: const Text('حفظ التعديلات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                     ),
                   ),
                   const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
