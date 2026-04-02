import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'project_item.dart'; 
class ItemsListContainer extends StatefulWidget {
  final String projectId;

  const ItemsListContainer({super.key, required this.projectId});

  @override
  State<ItemsListContainer> createState() => _ItemsListContainerState();
}

class _ItemsListContainerState extends State<ItemsListContainer> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final response = await _supabase
          .from('products') // Asegúrate de que el nombre de la tabla coincida
          .select()
          .eq('id_location', widget.projectId);

      setState(() {
        _items = response;
        _isLoading = false;
      });
    } catch (e) {
      // print('✖️Error cargando materiales: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // - 1. Loading State
    if (_isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    // - 2. If no items are found
    if (_items.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No hay materiales registrados.',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    // - 3. The actual list container
    return Expanded(
      child: Container(
        color: const Color(0xFF151515), 
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];

            return MaterialItemCard(
              name: item['name'] ?? 'Material sin nombre',
              quantity: item['quantity'] ?? 0,
              unit: item['unit_measurement'] ?? 'ud',
              // Lógica simple para el color de categoría
              categoryColor: _getCategoryColor(item['category']),
              onEdit: () {
                print('Editando: ${item['name']}');
                // Aquí abrirías tu modal de edición
              },
              onMore: () {
                print('Mostrando más de: ${item['name']}');
                // Aquí abrirías el menú de opciones extra
              },
            );
          },
        ),
      ),
    );
  }

  // Función auxiliar para los colores de la barrita izquierda
  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'herramienta':
        return Color(0xFFFF0004);
      case 'fontaneria':
        return Color(0xFF36BCFF);
      case 'electrico':
        return Color(0xFFFFEA00);
      case 'material':
        return Color(0xFFC1C1C1);
      default:
        return Colors.teal; // Tu turquesa para el resto
    }
  }
}