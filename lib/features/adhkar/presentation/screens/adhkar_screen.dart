import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/di.dart';
import '../bloc/adhkar_cubit.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdhkarCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الاستغفار', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<AdhkarCubit, AdhkarState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.currentItem?.text ?? 'جاري التحميل...',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      fontFamily: 'Amiri',
                    ),
                  ),
                  const SizedBox(height: 64),
                  GestureDetector(
                    onTap: state.isCompleted ? null : () => context.read<AdhkarCubit>().increment(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CircularProgressIndicator(
                            value: state.count / (state.currentItem?.target ?? 100),
                            strokeWidth: 14,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              state.isCompleted ? Colors.green : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\${state.count}',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 80,
                                color: state.isCompleted ? Colors.green : null,
                              ),
                            ),
                            Text(
                              '/ \${state.currentItem?.target ?? 0}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),
                  if (state.isCompleted)
                    Column(
                      children: [
                        const Text('تقبل الله طاعتك!', style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.read<AdhkarCubit>().reset(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة للبدء من جديد'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => context.read<AdhkarCubit>().reset(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('تصفير العداد'),
                      style: ElevatedButton.styleFrom(
                         backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                         foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                         elevation: 0,
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      )
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
