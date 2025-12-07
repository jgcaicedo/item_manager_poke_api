import 'package:flutter/material.dart';

/// Clase utilitaria para manejar tamaños y responsividad usando MediaQuery.
/// Proporciona métodos para obtener dimensiones y detectar tipo de dispositivo.
class Responsive {
  final BuildContext context;
  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get shortestSide => MediaQuery.of(context).size.shortestSide;
  double get longestSide => MediaQuery.of(context).size.longestSide;

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1200;
  bool get isDesktop => width >= 1200;

  double wp(double percent) => width * percent / 100;
  double hp(double percent) => height * percent / 100;
}
