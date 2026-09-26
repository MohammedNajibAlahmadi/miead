import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(const AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() async {
    final settings = await _repository.getSettings();
    emit(settings);
  }

  void updateTheme(String mode) async {
    await _repository.updateThemeMode(mode);
    emit(AppSettings(themeMode: mode, isFirstRun: state.isFirstRun));
  }

  void completeFirstRun() async {
    await _repository.setFirstRunCompleted();
    emit(AppSettings(themeMode: state.themeMode, isFirstRun: false));
  }
}
