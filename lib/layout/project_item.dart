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
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: IntrinsicHeight( // : Makes the card take the height of its tallest child
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // - 1. Var of category color (Vertical)
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

            // - 2. Center content (Name + Quantity)
            Expanded(
              child: Container(
                color: colors.surface, 
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: colors.tertiary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$unit: $quantity',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // - 3. Button section
            SizedBox(
              width: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // : Top button: Edit
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(4),
                      color: colors.primary,
                      child: InkWell(
                        onTap: onEdit,
                        child: const Center(
                          child: Icon(Icons.edit_note_rounded, color: Colors.black, size: 20),
                        ),
                      ),
                    ),
                  ),

                  // : Bottom button: MORE
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(4),
                      color: colors.secondary, 
                      child: InkWell(
                        onTap: onMore,
                        child: const Center(
                          child: Icon(Icons.pending, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}