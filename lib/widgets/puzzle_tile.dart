import 'package:flutter/material.dart';

/// Una pieza del rompecabezas: un cuadro con un número que se puede tocar.
/// No sabe nada de las reglas del juego, solo se dibuja y avisa cuando
/// la tocan. Por eso es un StatelessWidget: no tiene estado propio.
class PuzzleTile extends StatelessWidget {
  const PuzzleTile({
    super.key,
    required this.number,
    required this.color,
    required this.onTap,
  });

  /// Número que se muestra en la pieza.
  final int number;

  /// Color de fondo (así luego el estilo "colorido" solo cambia este valor).
  final Color color;

  /// Función que se ejecuta cuando el usuario toca la pieza.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Elegimos texto blanco u oscuro según el fondo, para que siempre se lea.
    final textColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black87;

    return Material(
      color: color,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
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
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}