import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zitoun/db/products.dart';

class PieChartPainter extends CustomPainter {
  final Map<String, int> data;
  final List<Color> colors;
  final int total;
  

  PieChartPainter({
    required this.data,
    required this.colors,
    required this.total,
  });

  
  
  @override
  void paint(Canvas canvas, Size size) {

    
    

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2;
    int index = 0;

    data.forEach((_, value) {
      final sweep = (value / total) * 2 * pi;

      final paint = Paint()
        ..color = colors[index % colors.length]
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
      index++;
    });

    // Donut hole
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()..color = Colors.transparent,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}

class PiGraph extends StatelessWidget {
  const PiGraph({super.key});

  void addData(Map<String, int> map) {
    for (final product in productNames) {
      map[product] = productTotalQuantities[productNames.indexOf(product)].toInt();
    }
   }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, int> data = {
     
    };

    addData(data);
    final total = data.values.fold(0, (a, b) => a + b);

    final colors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.yellowAccent,
      Colors.cyanAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.limeAccent,
      
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;

        return Flex(
          direction: isNarrow ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- CHART ---
            SizedBox(
              height: 120,
              width: 120,
              child: CustomPaint(
                painter: PieChartPainter(
                  data: data,
                  colors: colors,
                  total: total,
                ),
              ),
            ),

            SizedBox(width: isNarrow ? 0 : 16, height: isNarrow ? 16 : 0),

            // --- LEGEND ---
            SizedBox(
              width: isNarrow ? double.infinity : constraints.maxWidth - 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.entries.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final label = entry.value.key;
                  final value = entry.value.value;
                  final percent = (value / total) * 100;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "$label (${percent.toStringAsFixed(0)}%)",
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}