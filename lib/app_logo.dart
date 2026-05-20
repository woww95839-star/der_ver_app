import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showShadow;

  const AppLogo({
    super.key,
    this.size = 100,
    this.color,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Utilisation de la couleur passée ou du bordeaux par défaut de l'image
    final primaryColor = color ?? const Color(0xFF7B1111);
    final secondaryColor = color != null ? color!.withOpacity(0.8) : const Color(0xFF2D0505);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: size * 0.15,
                  offset: Offset(0, size * 0.08),
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Fond dégradé (Basé sur l'image envoyée)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
                center: const Alignment(0, -0.3),
                radius: 1.0,
              ),
            ),
          ),

          // 2. Effet Glossy (Reflet vitré)
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: GlossyClipper(),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 3. Le Bouclier (Shield) Noir et Blanc
          Positioned(
            top: size * 0.15,
            child: SizedBox(
              width: size * 0.55,
              height: size * 0.65,
              child: Stack(
                children: [
                  // Partie gauche (Noir brillant)
                  ClipPath(
                    clipper: ShieldClipperLeft(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF333333), Color(0xFF000000)],
                          begin: Alignment.topLeft,
                        ),
                      ),
                    ),
                  ),
                  // Partie droite (Blanc pur)
                  ClipPath(
                    clipper: ShieldClipperRight(),
                    child: Container(color: Colors.white),
                  ),
                  // Bordure Argentée
                  CustomPaint(
                    size: Size(size * 0.55, size * 0.65),
                    painter: ShieldBorderPainter(),
                  ),
                ],
              ),
            ),
          ),

          // 4. Texte "ALERTS"
          Positioned(
            bottom: size * 0.1,
            child: Text(
              "ALERTS",
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlossyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.45);
    path.quadraticBezierTo(size.width / 2, size.height * 0.6, size.width, size.height * 0.45);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ShieldClipperLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.05, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.05, size.height * 0.75, size.width / 2, size.height);
    path.lineTo(size.width / 2, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ShieldClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.95, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.95, size.height * 0.75, size.width / 2, size.height);
    path.lineTo(size.width / 2, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ShieldBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.95, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.95, size.height * 0.75, size.width / 2, size.height);
    path.quadraticBezierTo(size.width * 0.05, size.height * 0.75, size.width * 0.05, size.height * 0.15);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
