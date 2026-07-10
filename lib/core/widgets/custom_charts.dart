import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../app/app_text_style.dart';

// --- Custom Line Chart ---
class CustomLineChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;

  const CustomLineChart({
    super.key,
    required this.data,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _LineChartPainter(data: data),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map((l) => Text(l, style: AppTextStyle.bodySmall)).toList(),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;

  _LineChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final paintGrid = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final maxVal = data.reduce(max);
    final minVal = data.reduce(min);
    final range = maxVal == minVal ? 1.0 : (maxVal - minVal);

    // Draw horizontal grid lines
    const int gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final double stepX = size.width / (data.length - 1);
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedY = (data[i] - minVal) / range;
      final y = size.height - (normalizedY * size.height * 0.7 + size.height * 0.15);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == data.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    // Draw area fill gradient (vibrant blue to transparent)
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.primaryBlue.withOpacity(0.15), AppColors.primaryBlue.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Draw path line
    canvas.drawPath(path, paintLine);

    // Draw data points with white core
    final pointOuterPaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.fill;
    final pointInnerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedY = (data[i] - minVal) / range;
      final y = size.height - (normalizedY * size.height * 0.7 + size.height * 0.15);
      canvas.drawCircle(Offset(x, y), 5, pointOuterPaint);
      canvas.drawCircle(Offset(x, y), 2.5, pointInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Custom Pie Chart (Donut style with center total label) ---
class CustomPieChart extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;

  const CustomPieChart({
    super.key,
    required this.values,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: _PieChartPainter(values: values, colors: colors),
          size: Size.infinite,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '1,248',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            Text(
              'Total',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _PieChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = values.fold(0, (sum, item) => sum + item);
    if (total == 0) return;

    double startAngle = -pi / 2;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    // Donut chart white overlay
    final centerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      min(size.width, size.height) / 3.2,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Custom Bar Chart ---
class CustomBarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;

  const CustomBarChart({
    super.key,
    required this.data,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _BarChartPainter(data: data),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map((l) => Text(l, style: AppTextStyle.bodySmall)).toList(),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;

  _BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce(max);
    final double spacing = 12.0;
    final double totalSpacing = spacing * (data.length + 1);
    final double barWidth = (size.width - totalSpacing) / data.length;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final double x = spacing + i * (barWidth + spacing);
      final double normalizedHeight = maxVal == 0 ? 0 : (data[i] / maxVal);
      final double y = size.height - (normalizedHeight * size.height * 0.9);

      // Gradient fill for bars
      paint.shader = LinearGradient(
        colors: [AppColors.primaryBlue, AppColors.primaryBlue.withOpacity(0.5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(x, y, barWidth, size.height - y));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, size.height - y),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
