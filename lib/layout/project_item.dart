import 'package:flutter/material.dart';

class MaterialItemCard extends StatelessWidget {
  final String name;
  final int quantity;
  final String unit;
  final Color categoryColor;
  final VoidCallback onEdit;
  final VoidCallback onMore;

  const MaterialItemCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.categoryColor,
    required this.onEdit,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: IntrinsicHeight( // Hace que los hijos tengan la misma altura
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Barra de Categoría (Variable)
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),

            // 2. Contenido Central
            Expanded(
              child: Container(
                color: const Color(0xFF212121), // Tu gris de superficie
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unidad: $quantity $unit',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Botón EDIT (Vertical)
            Material(
              color: const Color(0xFFFFC107), // Tu amarillo primario
              child: InkWell(
                onTap: onEdit,
                child: const SizedBox(
                  width: 40,
                  child: Center(
                    child: Icon(Icons.edit, color: Colors.black, size: 20),
                  ),
                ),
              ),
            ),

            // 4. Botón MORE (Vertical)
            Material(
              color: const Color(0xFF333333), // Gris oscuro para diferenciar
              child: InkWell(
                onTap: onMore,
                child: const SizedBox(
                  width: 40,
                  child: Center(
                    child: Icon(Icons.more_vert, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}