import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color errorColor;
  final Color successColor;

  CustomColors({required this.errorColor, required this.successColor});

  @override
  CustomColors copyWith({Color? errorColor, Color? successColor}) {
    return CustomColors(
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
    );
  }
}