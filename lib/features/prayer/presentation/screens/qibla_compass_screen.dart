import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/di.dart';
import '../bloc/qibla_cubit.dart';

class QiblaCompassScreen extends StatelessWidget {
  const QiblaCompassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QiblaCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بوصلة القبلة', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<QiblaCubit, QiblaState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage.isNotEmpty) {
              return Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)));
            }

            // The angle the compass needs to rotate to point North
            final compassAngle = -1 * (state.heading * (math.pi / 180));
            // The angle the Qibla needle needs to rotate relative to North
            final qiblaAngle = state.qiblaDirection * (math.pi / 180);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'اتجاه الكعبة المشرفة',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${state.qiblaDirection.toStringAsFixed(1)}°',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 64),
                // Compass Container
                GestureDetector(
                  onPanUpdate: (details) {
                    context.read<QiblaCubit>().updateHeading(details.delta.dx * 0.7);
                  },
                  child: Center(
                    child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Compass Dial (Background rotating to North)
                      Transform.rotate(
                        angle: compassAngle,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD4AF37), width: 8),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)
                            ]
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // North indicator
                              const Positioned(
                                top: 10,
                                child: Text('N', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red)),
                              ),
                              // East Indicator
                              const Positioned(
                                right: 10,
                                child: Text('E', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              ),
                              // South Indicator
                              const Positioned(
                                bottom: 10,
                                child: Text('S', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              ),
                              // West Indicator
                              const Positioned(
                                left: 10,
                                child: Text('W', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              ),
                              // Inner decorative circle
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Qibla Needle (Pointing correctly relative to the Dial)
                      Transform.rotate(
                         angle: compassAngle + qiblaAngle,
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             const Icon(Icons.arrow_upward_rounded, size: 80, color: Color(0xFF006A4E)),
                             Container(
                               width: 4, height: 100,
                               decoration: BoxDecoration(
                                 color: const Color(0xFF006A4E),
                                 borderRadius: BorderRadius.circular(2)
                               ),
                             ),
                             // Counter-weight
                             Container(
                               width: 16, height: 16,
                               decoration: const BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Color(0xFFD4AF37),
                               ),
                             )
                           ],
                         ),
                      ),
                    ],
                  ),
                ),
                ), // Close GestureDetector
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'قم بتدوير الهاتف لمعرفة الاتجاه بدقة.\n\n(في حال استخدام الكمبيوتر أو الويب: يمكنك سحب البوصلة يميناً ويساراً بإصبعك/الماوس لتدويرها يدوياً)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
