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
      // Traemos los materiales filtrados por el proyecto actual
      final response = await _supabase
          .from('materials') // Asegúrate de que el nombre de la tabla coincida
          .select()
          .eq('project_id', widget.projectId);

      setState(() {
        _items = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando materiales: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Estado de carga
    if (_isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    // 2. Si no hay materiales en este proyecto
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

    // 3. El contenedor de la lista real
    return Expanded(
      child: Container(
        color: const Color(0xFF151515), // Fondo negro principal
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];

            return MaterialItemCard(
              name: item['name'] ?? 'Material sin nombre',
              quantity: item['quantity'] ?? 0,
              unit: item['unit_type'] ?? 'ud',
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
        return Colors.red;
      case 'consumible':
        return Colors.blue;
      case 'electrico':
        return Colors.amber;
      default:
        return Colors.teal; // Tu turquesa para el resto
    }
  }
}