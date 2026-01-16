import 'package:flutter/material.dart';



class CashFlowChart extends StatefulWidget {
  final List<CashFlowData> usdData;
  final List<CashFlowData> eurData;
  final bool showUsd;
  final bool showEur;

  const CashFlowChart({
    Key? key,
    required this.usdData,
    required this.eurData,
    this.showUsd = false,
    this.showEur = true,
  }) : super(key: key);

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  bool _showUsd = false;
  bool _showEur = true;

  @override
  void initState() {
    super.initState();
    _showUsd = widget.showUsd;
    _showEur = widget.showEur;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                '',//Cash Flow
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Row(
                children: [
                  _buildCurrencyToggle('quantity', _showUsd, Colors.redAccent, () {
                    setState(() => _showUsd = !_showUsd);
                  }),
                  const SizedBox(width: 12),
                  _buildCurrencyToggle('prix', _showEur, Colors.green.shade600, () {
                    setState(() => _showEur = !_showEur);
                  }),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Row(
                      children: [
                        /*
                        Text(
                          'This month',
                          style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, color:theme.colorScheme.onSurface, size: 18),*/
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CustomPaint(
              painter: CashFlowPainter(
                usdData: widget.usdData,
                eurData: widget.eurData,
                showUsd: _showUsd,
                showEur: _showEur,
                txtColor: theme.colorScheme.primary
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyToggle(String label, bool isActive, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 12,
              decoration: BoxDecoration(
                color:  theme.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CashFlowData {
  final String month;
  final double value;

  CashFlowData(this.month, this.value);
}

class CashFlowPainter extends CustomPainter {
  final List<CashFlowData> usdData;
  final List<CashFlowData> eurData;
  final bool showUsd;
  final bool showEur;
  final txtColor;
  CashFlowPainter({
    required this.usdData,
    required this.eurData,
    required this.showUsd,
    required this.showEur,
    required this.txtColor
  });
  
  @override
  void paint(Canvas canvas, Size size,) {
    final maxValue = _getMaxValue();
    final minValue = 0.0; 
    
    // Draw Y-axis labels
    _drawYAxisLabels(canvas, size, minValue, maxValue,txtColor);

    // Draw X-axis labels
    _drawXAxisLabels(canvas, size,txtColor);

    // Calculate chart area
    const leftMargin = 40.0;
    const rightMargin = 20.0;
    const topMargin = 10.0;
    const bottomMargin = 30.0;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;

    // Draw EUR data (behind USD)
    if (showEur && eurData.isNotEmpty) {
      _drawAreaChart(
        canvas,
        size,
        eurData,
        Colors.green.shade600,
        leftMargin,
        topMargin,
        chartWidth,
        chartHeight,
        minValue,
        maxValue,
      );
    }

    // Draw USD data (in front)
    if (showUsd && usdData.isNotEmpty) {
      _drawAreaChart(
        canvas,
        size,
        usdData,
        Colors.redAccent,
        leftMargin,
        topMargin,
        chartWidth,
        chartHeight,
        minValue,
        maxValue,
      );
    }
  }

  void _drawAreaChart(
    Canvas canvas,
    Size size,
    List<CashFlowData> data,
    Color color,
    double leftMargin,
    double topMargin,
    double chartWidth,
    double chartHeight,
    double minValue,
    double maxValue,
  ) {
    if (data.isEmpty) return;

    final path = Path();
    final points = <Offset>[];

    // Calculate points
    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + (i / (data.length - 1)) * chartWidth;
      final normalizedValue = (data[i].value - minValue) / (maxValue - minValue);
      final y = topMargin + chartHeight - (normalizedValue * chartHeight);
      points.add(Offset(x, y));
    }

    // Create smooth curve
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final cp1x = p0.dx + (p1.dx - p0.dx) / 2;
        final cp1y = p0.dy;
        final cp2x = p0.dx + (p1.dx - p0.dx) / 2;
        final cp2y = p1.dy;

        path.cubicTo(cp1x, cp1y, cp2x, cp2y, p1.dx, p1.dy);
      }

      // Close path for gradient fill
      path.lineTo(points.last.dx, topMargin + chartHeight);
      path.lineTo(leftMargin, topMargin + chartHeight);
      path.close();

      // Draw gradient fill
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.5),
          color.withOpacity(0.2),
          color.withOpacity(0.05),
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(leftMargin, topMargin, chartWidth, chartHeight),
        )
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);

      // Draw the line on top
      final linePath = Path();
      linePath.moveTo(points[0].dx, points[0].dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final cp1x = p0.dx + (p1.dx - p0.dx) / 2;
        final cp1y = p0.dy;
        final cp2x = p0.dx + (p1.dx - p0.dx) / 2;
        final cp2y = p1.dy;

        linePath.cubicTo(cp1x, cp1y, cp2x, cp2y, p1.dx, p1.dy);
      }

      final linePaint = Paint()
        ..color = color.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawPath(linePath, linePaint);
    }
  }

  void _drawYAxisLabels(Canvas canvas, Size size, double minValue, double maxValue,Color colorTxt) {
    const steps = 4;
    //const leftMargin = 40.0;

    for (int i = 0; i <= steps; i++) {
      final value = maxValue - (i * (maxValue - minValue) / steps);
      final y = 10 + (i / steps) * (size.height - 40);

      final textSpan = TextSpan(
        text: '${(value / 1000).toStringAsFixed(0)}k',
        style:  TextStyle(
          color: colorTxt,
          fontSize: 11,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }
  }

  void _drawXAxisLabels(Canvas canvas, Size size,Color txtColor) {
    final months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
    const leftMargin = 40.0;
    const rightMargin = 20.0;
    final chartWidth = size.width - leftMargin - rightMargin;

    for (int i = 0; i < months.length; i++) {
      final x = leftMargin + (i / (months.length - 1)) * chartWidth;

      final textSpan = TextSpan(
        text: months[i],
        style:  TextStyle(
          color: txtColor ,
          fontSize: 11,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 22),
      );
    }
  }

  double _getMaxValue() {
    double max = 0;
    if (showUsd) {
      for (var data in usdData) {
        if (data.value > max) max = data.value;
      }
    }
    if (showEur) {
      for (var data in eurData) {
        if (data.value > max) max = data.value;
      }
    }
    return max > 0 ? max : 4000;
  }

  @override
  bool shouldRepaint(CashFlowPainter oldDelegate) => true;
}

// Example usage:
class FinanceTrackingSection extends StatelessWidget {
  const FinanceTrackingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample data
    final usdData = [
      CashFlowData('Apr', 1800),
      CashFlowData('May', 2200),
      CashFlowData('Jun', 2800),
      CashFlowData('Jul', 3400),
      CashFlowData('Aug', 2900),
      CashFlowData('Sep', 3100),
      CashFlowData('Oct', 2700),
      CashFlowData('Nov', 3500),
      CashFlowData('Dec', 3000),
      CashFlowData('Jan', 3600),
      CashFlowData('Feb', 3200),
      CashFlowData('Mar', 3300),
    ];

    final eurData = [
      CashFlowData('Apr', 1500),
      CashFlowData('May', 2000),
      CashFlowData('Jun', 2400),
      CashFlowData('Jul', 3200),
      CashFlowData('Aug', 2600),
      CashFlowData('Sep', 0),
      CashFlowData('Oct', 0),
      CashFlowData('Nov', 0),
      CashFlowData('Dec', 0),
      CashFlowData('Jan', 0),
      CashFlowData('Feb', 0),
      CashFlowData('Mar', 0),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Finance Tracking",
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surface,
            border: Border.all(color: Colors.black12),
          ),
          child: CashFlowChart(
            usdData: usdData,
            eurData: eurData,
          ),
        ),
      ],
    );
  }
}