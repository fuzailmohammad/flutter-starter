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
    Future.delayed(const Duration(seconds: 2), () {
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
      duration: const Duration(seconds: 2),
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

  static const double gravity = 0.2;

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

enum Shape {
  Circle,
  Square,
  Triangle,
  Swirl,
  Line,
  // ColaBottle,
  // Balloon
}

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
          canvas.drawCircle(const Offset(0, 0), 6, paint);
          break;
        case Shape.Square:
          canvas.drawRect(const Rect.fromLTWH(-5, -5, 12, 12), paint);
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
          canvas.drawLine(const Offset(-10, 0), const Offset(10, 0), paint);
          break;
        // case Shape.ColaBottle:
        //   _drawColaBottle(canvas, paint);
        //   break;
        // case Shape.Balloon:
        //   _drawBalloonWithSwirlLine(canvas, paint);
        //   break;
      }

      canvas.restore();
    }
  }

  void _drawSwirl(Canvas canvas, Paint paint) {
    const double amplitude = 3; // Height of each wave
    const double wavelength = 10; // Width of each wave
    const int waveCount = 3; // Number of waves
    const double step = 0.5; // Step for smoothness

    Path path = Path();
    path.moveTo(-wavelength * waveCount / 2, 0);

    for (double x = -wavelength * waveCount / 2;
        x <= wavelength * waveCount / 2;
        x += step) {
      double y = amplitude * sin((2 * pi / wavelength) * x);
      path.lineTo(x, y);
    }

    paint.style =
        PaintingStyle.stroke; // Set paint style to stroke for line only
    paint.strokeWidth = 2.0; // Adjust the stroke width for the line

    canvas.drawPath(path, paint);
    paint.style = PaintingStyle.fill;
  }

  void _drawColaBottle(Canvas canvas, Paint paint) {
    Path path = Path();
    path.moveTo(202.59, 484.07);
    path.lineTo(201.68, 483.47);
    path.lineTo(199.96, 481.88);
    path.lineTo(199.11, 481.03);
    path.lineTo(197.54, 478.98);
    path.lineTo(196.78, 477.91);
    path.lineTo(195.38, 475.48);
    path.lineTo(194.71, 474.22);
    path.lineTo(193.52, 471.47);
    path.lineTo(192.95, 470.06);
    path.lineTo(191.99, 467.05);
    path.lineTo(191.55, 465.52);
    path.lineTo(190.85, 462.33);
    path.lineTo(190.53, 460.72);
    path.lineTo(190.12, 457.41);
    path.lineTo(189.86, 452.4);
    path.lineTo(189.85, 451.31);
    path.lineTo(189.89, 449.39);
    path.lineTo(189.93, 448.45);
    path.lineTo(190.08, 446.66);
    path.lineTo(190.18, 445.77);
    path.lineTo(190.51, 443.92);
    path.lineTo(190.7, 442.97);
    path.lineTo(191.25, 440.87);
    path.lineTo(191.56, 439.76);
    path.lineTo(192.4, 437.2);
    path.lineTo(192.86, 435.84);
    path.lineTo(194.05, 432.61);
    path.lineTo(194.68, 430.9);
    path.lineTo(196.26, 426.81);
    path.lineTo(196.69, 425.73);
    path.lineTo(197.62, 423.36);
    path.lineTo(199.14, 419.5);
    path.lineTo(203.5, 408.5);
    path.lineTo(203.37, 381);
    path.lineTo(203.35, 377);
    path.lineTo(203.24, 369.55);
    path.lineTo(203.16, 365.91);
    path.lineTo(202.94, 359.12);
    path.lineTo(202.81, 355.81);
    path.lineTo(202.46, 349.61);
    path.lineTo(202.26, 346.58);
    path.lineTo(201.79, 340.9);
    path.lineTo(201.53, 338.12);
    path.lineTo(200.92, 332.87);
    path.lineTo(200.6, 330.29);
    path.lineTo(199.84, 325.4);
    path.lineTo(199.45, 322.99);
    path.lineTo(198.55, 318.37);
    path.lineTo(197.02, 311.68);
    path.lineTo(195.91, 307.23);
    path.lineTo(194.18, 298.79);
    path.lineTo(193.78, 296.67);
    path.lineTo(193.1, 292.37);
    path.lineTo(192.77, 290.19);
    path.lineTo(192.21, 285.65);
    path.lineTo(191.94, 283.34);
    path.lineTo(191.49, 278.43);
    path.lineTo(191.27, 275.92);
    path.lineTo(190.91, 270.48);
    path.lineTo(190.74, 267.69);
    path.lineTo(190.45, 261.58);
    path.lineTo(190.07, 251.5);
    path.lineTo(189.95, 247.75);
    path.lineTo(189.8, 240.74);
    path.lineTo(189.75, 237.31);
    path.lineTo(189.72, 230.92);
    path.lineTo(189.72, 227.8);
    path.lineTo(189.81, 222.03);
    path.lineTo(189.87, 219.22);
    path.lineTo(190.08, 214.05);
    path.lineTo(190.2, 211.53);
    path.lineTo(190.53, 206.95);
    path.lineTo(190.71, 204.73);
    path.lineTo(191.16, 200.73);
    path.lineTo(191.4, 198.8);
    path.lineTo(191.97, 195.36);
    path.lineTo(192.96, 190.83);
    path.lineTo(193.1, 190.3);
    path.lineTo(193.54, 188.92);
    path.lineTo(193.78, 188.17);
    path.lineTo(194.41, 186.41);
    path.lineTo(194.74, 185.48);
    path.lineTo(195.52, 183.41);
    path.lineTo(195.93, 182.34);
    path.lineTo(196.84, 180.03);
    path.lineTo(197.79, 177.67);
    path.lineTo(199.94, 172.55);
    path.lineTo(203.34, 164.83);
    path.lineTo(204.21, 162.91);
    path.lineTo(205.86, 159.27);
    path.lineTo(206.66, 157.48);
    path.lineTo(208.17, 154.06);
    path.lineTo(209.65, 150.7);
    path.lineTo(212.26, 144.56);
    path.lineTo(213.51, 141.57);
    path.lineTo(215.7, 136.03);
    path.lineTo(216.76, 133.31);
    path.lineTo(218.61, 128.17);
    path.lineTo(219.5, 125.63);
    path.lineTo(221.08, 120.68);
    path.lineTo(221.84, 118.22);
    path.lineTo(223.22, 113.28);
    path.lineTo(223.88, 110.79);
    path.lineTo(225.13, 105.65);
    path.lineTo(226.92, 97.5);
    path.lineTo(227.22, 96.06);
    path.lineTo(227.82, 92.82);
    path.lineTo(228.13, 91.16);
    path.lineTo(228.72, 87.6);
    path.lineTo(229.31, 84);
    path.lineTo(230.36, 76.58);
    path.lineTo(230.6, 74.77);
    path.lineTo(231.02, 71.31);
    path.lineTo(231.22, 69.62);
    path.lineTo(231.54, 66.54);
    path.lineTo(231.69, 65.07);
    path.lineTo(231.88, 62.54);
    path.lineTo(232, 59.57);
    path.lineTo(232, 58.38);
    path.lineTo(232.18, 55.6);
    path.lineTo(232.24, 54.93);
    path.lineTo(232.38, 53.68);
    path.lineTo(232.62, 52.12);
    path.lineTo(233.25, 49);
    path.lineTo(256.01, 49);
    path.lineTo(257.63, 49);
    path.lineTo(260.56, 48.99);
    path.lineTo(261.97, 48.99);
    path.lineTo(264.5, 48.98);
    path.lineTo(265.72, 48.98);
    path.lineTo(267.87, 48.99);
    path.lineTo(268.91, 49);
    path.lineTo(270.72, 49.04);
    path.lineTo(271.59, 49.06);
    path.lineTo(273.08, 49.13);
    path.lineTo(273.8, 49.17);
    path.lineTo(275.01, 49.29);
    path.lineTo(276.16, 49.43);
    path.lineTo(277.74, 49.9);
    path.lineTo(278.42, 50.18);
    path.lineTo(279.24, 51);
    path.lineTo(279.58, 51.47);
    path.lineTo(279.88, 52.74);
    path.lineTo(279.99, 53.44);
    path.lineTo(280.01, 55.26);
    path.lineTo(279.99, 58.7);
    path.lineTo(279.99, 59.06);
    path.lineTo(280.02, 59.98);
    path.lineTo(280.04, 60.48);
    path.lineTo(280.11, 61.65);
    path.lineTo(280.19, 62.87);
    path.lineTo(280.44, 65.84);
    path.lineTo(281.51, 75.7);
    path.lineTo(281.96, 79.28);
    path.lineTo(283.03, 86.23);
    path.lineTo(283.59, 89.67);
    path.lineTo(284.87, 96.38);
    path.lineTo(285.54, 99.71);
    path.lineTo(287.05, 106.25);
    path.lineTo(287.84, 109.51);
    path.lineTo(289.62, 115.95);
    path.lineTo(290.54, 119.17);
    path.lineTo(292.59, 125.57);
    path.lineTo(293.65, 128.78);
    path.lineTo(295.99, 135.22);
    path.lineTo(297.19, 138.45);
    path.lineTo(299.85, 144.98);
    path.lineTo(304.2, 154.97);
    path.lineTo(305.42, 157.65);
    path.lineTo(307.58, 162.44);
    path.lineTo(308.61, 164.75);
    path.lineTo(310.43, 168.88);
    path.lineTo(311.31, 170.86);
    path.lineTo(312.82, 174.4);
    path.lineTo(313.55, 176.1);
    path.lineTo(314.8, 179.13);
    path.lineTo(315.39, 180.59);
    path.lineTo(316.4, 183.19);
    path.lineTo(316.87, 184.44);
    path.lineTo(317.68, 186.69);
    path.lineTo(318.06, 187.77);
    path.lineTo(318.68, 189.75);
    path.lineTo(319.46, 192.5);
    path.lineTo(319.8, 193.79);
    path.lineTo(320.39, 196.87);
    path.lineTo(320.67, 198.49);
    path.lineTo(321.15, 202.18);
    path.lineTo(321.37, 204.11);
    path.lineTo(321.74, 208.4);
    path.lineTo(321.9, 210.62);
    path.lineTo(322.15, 215.48);
    path.lineTo(322.26, 217.98);
    path.lineTo(322.39, 223.39);
    path.lineTo(322.44, 226.15);
    path.lineTo(322.45, 232.08);
    path.lineTo(322.44, 235.1);
    path.lineTo(322.33, 241.52);
    path.lineTo(322.03, 251.66);
    path.lineTo(321.9, 255.28);
    path.lineTo(321.6, 261.81);
    path.lineTo(321.45, 264.97);
    path.lineTo(321.1, 270.72);
    path.lineTo(320.91, 273.51);
    path.lineTo(320.49, 278.64);
    path.lineTo(320.27, 281.14);
    path.lineTo(319.76, 285.81);
    path.lineTo(319.49, 288.1);
    path.lineTo(318.87, 292.47);
    path.lineTo(318.54, 294.63);
    path.lineTo(317.79, 298.86);
    path.lineTo(314.96, 311.77);
    path.lineTo(313.96, 315.84);
    path.lineTo(312.35, 324.48);
    path.lineTo(311.97, 326.71);
    path.lineTo(311.31, 331.41);
    path.lineTo(310.99, 333.81);
    path.lineTo(310.44, 338.9);
    path.lineTo(310.18, 341.5);
    path.lineTo(309.72, 347.07);
    path.lineTo(309.51, 349.92);
    path.lineTo(309.15, 356.06);
    path.lineTo(308.97, 359.2);
    path.lineTo(308.69, 365.99);
    path.lineTo(308.35, 377);
    path.lineTo(308.31, 378.83);
    path.lineTo(308.23, 382.16);
    path.lineTo(308.19, 383.78);
    path.lineTo(308.14, 386.72);
    path.lineTo(308.11, 388.15);
    path.lineTo(308.08, 390.75);
    path.lineTo(308.07, 392.02);
    path.lineTo(308.08, 394.33);
    path.lineTo(308.1, 396.57);
    path.lineTo(308.27, 400.39);
    path.lineTo(308.38, 402.22);
    path.lineTo(308.8, 405.48);
    path.lineTo(309.04, 407.08);
    path.lineTo(309.74, 410.18);
    path.lineTo(310.14, 411.75);
    path.lineTo(311.2, 415.06);
    path.lineTo(311.78, 416.78);
    path.lineTo(313.25, 420.69);
    path.lineTo(313.65, 421.72);
    path.lineTo(314.52, 423.97);
    path.lineTo(315.98, 427.64);
    path.lineTo(316.67, 429.39);
    path.lineTo(318, 433.02);
    path.lineTo(318.65, 434.83);
    path.lineTo(319.8, 438.29);
    path.lineTo(320.34, 439.96);
    path.lineTo(321.18, 442.85);
    path.lineTo(321.36, 443.51);
    path.lineTo(321.65, 444.67);
    path.lineTo(321.94, 446.09);
    path.lineTo(322.21, 447.81);
    path.lineTo(322.39, 451.45);
    path.lineTo(322.42, 453.29);
    path.lineTo(322.12, 457.05);
    path.lineTo(321.92, 458.94);
    path.lineTo(321.21, 462.68);
    path.lineTo(320.8, 464.54);
    path.lineTo(319.71, 468.14);
    path.lineTo(319.12, 469.91);
    path.lineTo(317.7, 473.22);
    path.lineTo(316.95, 474.83);
    path.lineTo(315.25, 477.72);
    path.lineTo(314.36, 479.1);
    path.lineTo(312.41, 481.44);
    path.lineTo(309.27, 484.16);
    path.lineTo(308.95, 484.37);
    path.lineTo(308.17, 484.73);
    path.lineTo(307.74, 484.9);
    path.lineTo(306.5, 485.17);
    path.lineTo(305.78, 485.29);
    path.lineTo(303.73, 485.49);
    path.lineTo(303.15, 485.53);
    path.lineTo(301.78, 485.61);
    path.lineTo(301.06, 485.65);
    path.lineTo(299.37, 485.71);
    path.lineTo(298.49, 485.74);
    path.lineTo(296.44, 485.8);
    path.lineTo(295.37, 485.82);
    path.lineTo(292.93, 485.86);
    path.lineTo(291.65, 485.88);
    path.lineTo(288.76, 485.91);
    path.lineTo(287.26, 485.92);
    path.lineTo(283.88, 485.94);
    path.lineTo(282.13, 485.95);
    path.lineTo(278.23, 485.96);
    path.lineTo(276.21, 485.97);
    path.lineTo(271.74, 485.98);
    path.lineTo(269.43, 485.98);
    path.lineTo(264.35, 485.99);
    path.lineTo(256, 485.99);
    path.lineTo(252.99, 485.99);
    path.lineTo(247.5, 485.99);
    path.lineTo(244.84, 485.98);
    path.lineTo(240, 485.98);
    path.lineTo(237.66, 485.98);
    path.lineTo(233.44, 485.97);
    path.lineTo(231.4, 485.96);
    path.lineTo(227.74, 485.94);
    path.lineTo(225.98, 485.93);
    path.lineTo(222.84, 485.91);
    path.lineTo(221.34, 485.9);
    path.lineTo(218.68, 485.86);
    path.lineTo(217.41, 485.84);
    path.lineTo(215.18, 485.8);
    path.lineTo(214.12, 485.77);
    path.lineTo(212.29, 485.71);
    path.lineTo(211.41, 485.68);
    path.lineTo(209.92, 485.61);
    path.lineTo(209.21, 485.57);
    path.lineTo(208.02, 485.48);
    path.lineTo(206.89, 485.38);
    path.lineTo(205.34, 485.14);
    path.lineTo(204.65, 485.01);
    path.lineTo(203.7, 484.67);
    path.lineTo(203.28, 484.5);
    path.moveTo(225, 39);
    path.lineTo(224.38, 38.38);
    path.lineTo(223.54, 36.6);
    path.lineTo(223, 33.5);
    path.lineTo(223, 32.42);
    path.lineTo(223.54, 30.4);
    path.lineTo(225, 28);
    path.lineTo(225.24, 27.76);
    path.lineTo(225.75, 27.37);
    path.lineTo(226.02, 27.18);
    path.lineTo(226.76, 26.88);
    path.lineTo(227.18, 26.74);
    path.lineTo(228.35, 26.53);
    path.lineTo(229.02, 26.43);
    path.lineTo(230.84, 26.28);
    path.lineTo(231.85, 26.22);
    path.lineTo(234.54, 26.13);
    path.lineTo(235.27, 26.11);
    path.lineTo(236.93, 26.08);
    path.lineTo(237.8, 26.07);
    path.lineTo(239.75, 26.04);
    path.lineTo(240.77, 26.03);
    path.lineTo(243.03, 26.02);
    path.lineTo(244.2, 26.02);
    path.lineTo(246.8, 26.01);
    path.lineTo(248.15, 26);
    path.lineTo(251.11, 26);
    path.lineTo(256, 26);
    path.lineTo(257.73, 26);
    path.lineTo(260.89, 26);
    path.lineTo(262.42, 26);
    path.lineTo(265.2, 26.01);
    path.lineTo(266.54, 26.01);
    path.lineTo(268.97, 26.02);
    path.lineTo(270.14, 26.03);
    path.lineTo(272.25, 26.04);
    path.lineTo(273.26, 26.05);
    path.lineTo(275.07, 26.08);
    path.lineTo(275.93, 26.09);
    path.lineTo(277.46, 26.13);
    path.lineTo(278.93, 26.17);
    path.lineTo(281.16, 26.28);
    path.lineTo(282.17, 26.35);
    path.lineTo(283.65, 26.53);
    path.lineTo(284.31, 26.63);
    path.lineTo(285.24, 26.88);
    path.lineTo(285.66, 27.02);
    path.lineTo(286.25, 27.37);
    path.lineTo(287, 28);
    path.lineTo(287.62, 28.62);
    path.lineTo(288.46, 30.4);
    path.lineTo(289, 33.5);
    path.lineTo(289, 34.58);
    path.lineTo(288.46, 36.6);
    path.lineTo(287, 39);
    path.lineTo(286.76, 39.24);
    path.lineTo(286.25, 39.63);
    path.lineTo(285.98, 39.82);
    path.lineTo(285.24, 40.12);
    path.lineTo(284.82, 40.26);
    path.lineTo(283.65, 40.47);
    path.lineTo(282.98, 40.57);
    path.lineTo(281.16, 40.72);
    path.lineTo(280.15, 40.78);
    path.lineTo(277.46, 40.87);
    path.lineTo(276.73, 40.89);
    path.lineTo(275.07, 40.92);
    path.lineTo(274.2, 40.93);
    path.lineTo(272.25, 40.96);
    path.lineTo(271.23, 40.97);
    path.lineTo(268.97, 40.98);
    path.lineTo(267.8, 40.98);
    path.lineTo(265.2, 40.99);
    path.lineTo(263.85, 41);
    path.lineTo(260.89, 41);
    path.lineTo(256, 41);
    path.lineTo(254.27, 41);
    path.lineTo(251.11, 41);
    path.lineTo(249.58, 41);
    path.lineTo(246.8, 40.99);
    path.lineTo(245.46, 40.99);
    path.lineTo(243.03, 40.98);
    path.lineTo(241.86, 40.97);
    path.lineTo(239.75, 40.96);
    path.lineTo(238.74, 40.95);
    path.lineTo(236.93, 40.92);
    path.lineTo(236.07, 40.91);
    path.lineTo(234.54, 40.87);
    path.lineTo(233.07, 40.83);
    path.lineTo(230.84, 40.72);
    path.lineTo(229.83, 40.65);
    path.lineTo(228.35, 40.47);
    path.lineTo(227.69, 40.37);
    path.lineTo(226.76, 40.12);
    path.lineTo(226.34, 39.98);
    path.lineTo(225.75, 39.63);
    path.lineTo(225.47, 39.45);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBalloonWithSwirlLine(Canvas canvas, Paint paint) {
    Path path = Path();

    // Drawing the balloon
    Rect balloonRect =
        Rect.fromCircle(center: const Offset(0, -10), radius: 10);
    path.addOval(balloonRect);

    // Drawing the balloon's string with a swirl line
    const double amplitude = 4; // Height of each wave
    const double wavelength = 8; // Width of each wave
    const double length = 20; // Length of the string
    const double step = 1.0; // Step for smoothness

    path.moveTo(0, balloonRect.bottom); // Start at the bottom of the balloon

    for (double x = 0; x <= length; x += step) {
      double y = amplitude * sin((2 * pi / wavelength) * x);
      path.lineTo(x - length / 2, balloonRect.bottom + x + y);
    }

    paint.style = PaintingStyle.stroke; // Only the outline
    paint.strokeWidth = 2.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
