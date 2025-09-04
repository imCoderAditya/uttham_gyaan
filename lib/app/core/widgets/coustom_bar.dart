// lib/widgets/custom_bar_chart.dart
import 'package:flutter/material.dart';
import '../../data/model/commissions/commissions_model.dart';

class CustomBarChart extends StatelessWidget {
  final List<Commission> commissions;

  const CustomBarChart({super.key, required this.commissions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomPaint(
        painter: BarChartPainter(commissions: commissions),
        child: Container(),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<Commission> commissions;

  BarChartPainter({required this.commissions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue[600]!;

    final maxAmount = commissions.isNotEmpty
        ? commissions.map((c) => c.amount).reduce((a, b) => a > b ? a : b)
        : 1000.0; // Default max for scaling
    final barWidth = size.width / (commissions.length * 2); // Dynamic bar width
    const spacing = 10.0;

    for (int i = 0; i < commissions.length; i++) {
      final barHeight = (commissions[i].amount / maxAmount) * (size.height - 20);
      final x = i * (barWidth + spacing);
      final rect = Rect.fromLTWH(
        x,
        size.height - barHeight,
        barWidth,
        barHeight,
      );
      canvas.drawRect(rect, paint);

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Comm ${i + 1}',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, size.height));

      // Draw amount
      final amountPainter = TextPainter(
        text: TextSpan(
          text: '\$${commissions[i].amount.toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      amountPainter.layout();
      amountPainter.paint(canvas, Offset(x, size.height - barHeight - 20));
    }

    // Draw y-axis labels
    final yAxisPainter = TextPainter(
      text: TextSpan(
        text: '\$${maxAmount.toStringAsFixed(0)}',
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    yAxisPainter.layout();
    yAxisPainter.paint(canvas, const Offset(0, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}