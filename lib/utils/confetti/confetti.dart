import 'dart:math';

import 'package:flutter/material.dart';

class Confetti {
  static void show(BuildContext context) {
    _showConfetti(context, null);
  }

  static void showWithPrimary(BuildContext context, Color primaryColor) {
    _showConfetti(context, primaryColor);
  }

  static void _showConfetti(BuildContext context, Color? primaryColor) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _ConfettiWidget(primaryColor: primaryColor),
    );
    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class _ConfettiWidget extends StatefulWidget {
  final Color? primaryColor;

  const _ConfettiWidget({this.primaryColor});

  @override
  _ConfettiWidgetState createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<_ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenSize = MediaQuery.of(context).size;
    _particles = List.generate(
      100,
      (index) => ConfettiParticle(
        screenSize: screenSize,
        primaryColor: widget.primaryColor,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ConfettiPainter(_controller, _particles),
      ),
    );
  }
}

class ConfettiParticle {
  late Offset position;
  late Offset velocity;
  late double angle;
  late Color color;
  late Shape shape;

  static const double gravity = 0.1;

  ConfettiParticle({required Size screenSize, Color? primaryColor}) {
    final random = Random();
    position = Offset(
      random.nextDouble() * screenSize.width,
      random.nextDouble() * screenSize.height / 2,
    );
    velocity = Offset(random.nextDouble() * 2 - 1, random.nextDouble() * -5);
    angle = random.nextDouble() * 2 * pi;

    if (primaryColor != null) {
      color = Color.fromRGBO(
        (primaryColor.red + random.nextInt(256)) ~/ 2,
        (primaryColor.green + random.nextInt(256)) ~/ 2,
        (primaryColor.blue + random.nextInt(256)) ~/ 2,
        1,
      );
    } else {
      color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );
    }

    shape = Shape.values[random.nextInt(Shape.values.length)];
  }

  void update() {
    velocity = Offset(velocity.dx, velocity.dy + gravity);
    position += velocity;
    angle += 0.1;
  }
}

enum Shape { Circle, Square, Triangle, Swirl, Line }

class _ConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final List<ConfettiParticle> particles;

  _ConfettiPainter(this.animation, this.particles) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      paint.color = particle.color;
      particle.update();

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.angle);

      switch (particle.shape) {
        case Shape.Circle:
          canvas.drawCircle(Offset(0, 0), 5, paint);
          break;
        case Shape.Square:
          canvas.drawRect(Rect.fromLTWH(-5, -5, 10, 10), paint);
          break;
        case Shape.Triangle:
          Path path = Path();
          path.moveTo(0, -5);
          path.lineTo(5, 5);
          path.lineTo(-5, 5);
          path.close();
          canvas.drawPath(path, paint);
          break;
        case Shape.Swirl:
          _drawSwirl(canvas, paint);
          break;
        case Shape.Line:
          canvas.drawLine(Offset(-5, 0), Offset(5, 0), paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawSwirl(Canvas canvas, Paint paint) {
    const double radius = 50;
    const double amplitude = 10;
    const double frequency = 0.1;
    const double angleIncrement = pi / 32;

    Path path = Path();
    double angle = 0;
    double x = 0;
    double y = 0;

    for (int i = 0; i < 360; i++) {
      double r = radius + amplitude * sin(angle * frequency);
      x = r * cos(angle);
      y = r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      angle += angleIncrement;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
