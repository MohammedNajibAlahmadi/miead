import 'package:flutter/material.dart';

class FocusDistributionChart extends StatelessWidget {
  final Map<String, int> distribution;

  const FocusDistributionChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalValue = distribution.values.fold<int>(0, (a, b) => a + b);
    if (totalValue == 0) return const SizedBox.shrink();

    final colors = [
      const Color(0xFFD4AF37),
      Theme.of(context).primaryColor,
      Colors.indigo,
      Colors.deepOrange,
      Colors.teal,
      Colors.blueGrey,
    ];

    int colorIndex = 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'التوزيع التحليلي للتركيز',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...distribution.entries.map((entry) {
              final val = entry.value;
              final pct = val / totalValue;
              final color = colors[colorIndex++ % colors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: pct,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 45,
                      child: Text(
                        '$val د',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
