import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miead/app/router/router.dart';
import 'package:miead/shared/themes/app_theme.dart';
import 'package:miead/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:miead/features/settings/data/repositories/settings_repository.dart';
import 'package:miead/app/dependency_injection/di.dart';

class MieadApp extends StatelessWidget {
  const MieadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          final mode = settings.themeMode == 'light'
              ? ThemeMode.light
              : settings.themeMode == 'dark'
                  ? ThemeMode.dark
                  : ThemeMode.system;

          return MaterialApp.router(
            title: 'Mie\'ad - مِيعاد',
            debugShowCheckedModeBanner: false,
            routerConfig: goRouter,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            builder: (context, child) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 550), // Restrict web stretching
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
