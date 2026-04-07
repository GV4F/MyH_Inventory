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
  final List<String> _categories = ['Todo', 'Herramienta', 'Material', 'Fontanería', 'Electricidad', 'Maquinaria'];
  String _selectedCategory = 'Todo';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Color(0xFF212121),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
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
                      color: Color(0xFFFCCC3E),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white12),
              const Text(
                'Categorías:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              Wrap(
                  spacing: 10.0, 
                  runSpacing: 10.0, 
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : 'Todo';
                        });
                      },
                      backgroundColor: const Color(0xFF333333),
                      selectedColor: const Color(0xFFFCCC3E), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFFFCCC3E) : Colors.transparent, 
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF121212) : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _selectedCategory;
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCCC3E), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Center(
                      child: Text(
                        'Aplicar Filtro',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ),
                  ),
                ),
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