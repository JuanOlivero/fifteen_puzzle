import 'package:flutter/material.dart';

/// Una pieza del rompecabezas: un cuadro con un número que se puede tocar.
/// No sabe nada de las reglas del juego ni de los estilos: solo se dibuja
/// con los colores que le pasan y avisa cuando la tocan.
class PuzzleTile extends StatelessWidget {
  const PuzzleTile({
    super.key,
    required this.number,
    required this.color,
    required this.onTap,
    this.textColor,
    this.borderColor,
    this.elevation = 2,
  });

  /// Número que se muestra en la pieza.
  final int number;

  /// Color de fondo.
  final Color color;

  /// Función que se ejecuta cuando el usuario toca la pieza.
  final VoidCallback onTap;

  /// Color del número. Si es null, se elige blanco u oscuro según el fondo.
  final Color? textColor;

  /// Color del borde. Si es null, la pieza no tiene borde.
  final Color? borderColor;

  /// Sombra de la pieza (0 = plana).
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final autoTextColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black87;
    final border = borderColor;

    return Material(
      color: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: border == null
            ? BorderSide.none
            : BorderSide(color: border, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          // FittedBox reduce el texto si la pieza es pequeña (por ejemplo
          // en el tablero 5x5), así nunca se desborda.
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? autoTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}