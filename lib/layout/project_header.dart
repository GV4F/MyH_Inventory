import 'package:flutter/material.dart';

class ProjectHeader extends StatefulWidget {
  final String projectName;
  const ProjectHeader({
    super.key, 
    required this.projectName
  });

  @override
  State<ProjectHeader> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<ProjectHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Función que levanta el modal de filtros
  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true, // Para que el modal pueda ocupar más espacio si es necesario
      backgroundColor: Colors.transparent, // Para poder redondear las esquinas desde el Container
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Color(0xFF212121), // El gris oscuro de tus tarjetas
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtros de Búsqueda',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Aquí irán tus opciones de filtro (ej. Dropdowns, Checkboxes)
              const Text('Categorías...', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 60), // Espacio de relleno temporal
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: const BoxDecoration(
        color: Color(0xFF0A2463),
      ),
      child: SafeArea(
        bottom: false, // Solo respeta el notch/barra de estado arriba
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FILA 1: Título y Usuario ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.projectName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'GVAF',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // --- FILA 2: Buscador y Filtro ---
            Row(
              children: [
                // Barra de búsqueda (Expanded para que tome todo el ancho posible)
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151515), // Tu negro de fondo principal
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Buscar material...',
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Colors.amber),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onChanged: (value) {
                        print('Buscando: $value');
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Filter Button
                GestureDetector(
                  onTap: _showFilterModal,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Fondo transparente
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune, 
                      color: Colors.amber,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}