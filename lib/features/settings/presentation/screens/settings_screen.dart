import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/settings_cubit.dart';
import '../../data/repositories/settings_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.analytics_outlined, color: Color(0xFFD4AF37)),
                title: const Text('الإحصائيات والتحليل'),
                subtitle: const Text('شاهد تقدمك ونسبة مهامك'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => GoRouter.of(context).push('/statistics'),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('المظهر والتصميم', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ),
              RadioListTile<String>(
                title: const Text('النظام (تلقائي)'),
                subtitle: const Text('يتبع إعدادات الهاتف بشكل آلي'),
                value: 'system',
                groupValue: settings.themeMode,
                onChanged: (val) => context.read<SettingsCubit>().updateTheme(val!),
              ),
              RadioListTile<String>(
                title: const Text('المظهر الفاتح'),
                value: 'light',
                groupValue: settings.themeMode,
                onChanged: (val) => context.read<SettingsCubit>().updateTheme(val!),
              ),
              RadioListTile<String>(
                title: const Text('المظهر الداكن'),
                value: 'dark',
                groupValue: settings.themeMode,
                onChanged: (val) => context.read<SettingsCubit>().updateTheme(val!),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('حول التطبيق', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('إصدار التطبيق'),
                subtitle: Text('1.0.0 (Local First)'),
              ),
              const ListTile(
                leading: Icon(Icons.security),
                title: Text('خصوصية البيانات'),
                subtitle: Text('جميع البيانات يتم حفظها في جهازك فقط (Offline). لا يتم إرسال أي تفاصيل للإنترنت.'),
              ),
            ],
          );
        },
      ),
    );
  }
}
