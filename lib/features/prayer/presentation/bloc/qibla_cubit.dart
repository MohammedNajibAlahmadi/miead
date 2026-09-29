import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class QiblaState extends Equatable {
  final double heading;
  final double qiblaDirection;
  final bool hasPermission;
  final bool isLoading;
  final String errorMessage;

  const QiblaState({
    required this.heading,
    required this.qiblaDirection,
    this.hasPermission = false,
    this.isLoading = true,
    this.errorMessage = '',
  });

  QiblaState copyWith({
    double? heading,
    double? qiblaDirection,
    bool? hasPermission,
    bool? isLoading,
    String? errorMessage,
  }) {
    return QiblaState(
      heading: heading ?? this.heading,
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      hasPermission: hasPermission ?? this.hasPermission,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [heading, qiblaDirection, hasPermission, isLoading, errorMessage];
}

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit() : super(const QiblaState(heading: 0, qiblaDirection: 0)) {
    _initCompass();
  }

  Future<void> _initCompass() async {
    // In a real device, you use flutter_compass and geolocator logic here.
    // We are simulating the streams so UI testing works offline gracefully.
    emit(state.copyWith(isLoading: false, hasPermission: true, qiblaDirection: 135.0 /* Mecca from NY approx */));
    
    // Default starting point
    emit(state.copyWith(heading: 0.0));
  }

  void updateHeading(double delta) {
    emit(state.copyWith(heading: (state.heading + delta) % 360));
  }
}
