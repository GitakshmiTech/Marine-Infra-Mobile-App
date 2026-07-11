import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../app/app_text_style.dart';
import 'mock_media_picker.dart';

class CustomSignaturePad extends StatefulWidget {
  final Function(List<Offset> points) onSignatureChanged;

  const CustomSignaturePad({
    super.key,
    required this.onSignatureChanged,
  });

  @override
  State<CustomSignaturePad> createState() => _CustomSignaturePadState();
}

class _CustomSignaturePadState extends State<CustomSignaturePad> {
  final List<Offset> _points = [];

  void _clear() {
    setState(() {
      _points.clear();
    });
    widget.onSignatureChanged(_points);
  }

  Future<void> _simulateUpload() async {
    final result = await MockMediaPicker.showFilePicker(
      context,
      allowedExtensions: ['png', 'jpg'],
    );
    if (result != null) {
      setState(() {
        _points.clear();
        // Cursive path representing the signature loaded from file
        _points.addAll([
          const Offset(40, 110),
          const Offset(55, 75),
          const Offset(65, 125),
          const Offset(85, 95),
          const Offset(105, 115),
          const Offset(120, 80),
          const Offset(140, 110),
          const Offset(155, 90),
          const Offset(175, 115),
          Offset.infinite,
          const Offset(70, 130),
          const Offset(180, 130),
          Offset.infinite,
        ]);
      });
      widget.onSignatureChanged(_points);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signature file "${result.name}" uploaded successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  RenderBox object = context.findRenderObject() as RenderBox;
                  Offset localPosition = object.globalToLocal(details.globalPosition);
                  // Clamp bounds
                  if (localPosition.dx >= 0 &&
                      localPosition.dx <= object.size.width &&
                      localPosition.dy >= 0 &&
                      localPosition.dy <= 200) {
                    _points.add(localPosition);
                  }
                });
                widget.onSignatureChanged(_points);
              },
              onPanEnd: (DragEndDetails details) {
                _points.add(Offset.infinite);
                widget.onSignatureChanged(_points);
              },
              child: CustomPaint(
                painter: SignaturePainter(points: _points),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: _simulateUpload,
              icon: const Icon(Icons.upload_file_rounded, size: 16, color: AppColors.primaryBlue),
              label: Text(
                'Upload Signature',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.clear, size: 16, color: AppColors.error),
              label: Text(
                'Clear',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset> points;

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.secondary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
