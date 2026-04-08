import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'project_item.dart'; 
import 'dart:async';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'modal_edit.dart';

class ItemsListContainer extends StatefulWidget {
  final String projectId;

  const ItemsListContainer({super.key, required this.projectId});

  @override
  State<ItemsListContainer> createState() => _ItemsListContainerState();
}

class _ItemsListContainerState extends State<ItemsListContainer> {
  StreamSubscription? _subscription;
  final _supabase = Supabase.instance.client;
  List<dynamic> _items = [];
  bool _isLoading = true;
  List<dynamic> projects = [];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _subscription?.cancel(); // : We cancel any existing subscription before starting a new one
    try {
        _subscription = _supabase
          .from('products')
          .stream(primaryKey: ['id'])
          .eq('id_location', widget.projectId)
          .listen((data) {
            setState(() {
              _items = data;
              _isLoading = false;
            });
          });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> projectsList() async {
    try {
      final response = await _supabase
        .from('locations')
        .select();
        setState(() {
          projects = response as List<dynamic>;
        });
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  // - ON EDIT
  void editItem(Map<String, dynamic> item) {
    projectsList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MoveItemModal(
          item: item,
          currentProjectId: widget.projectId,
          projects: projects,
        );
      },
    );
  }

  String formatSupabaseDate(String dateString) {
    DateTime date = DateTime.parse(dateString);

    return DateFormat('dd/MM/yyyy').format(date);
  }

  // - ON MORE
  void moreItem(BuildContext context, Map<String, dynamic> item) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20), 
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF151515).withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFCCC3E).withOpacity(0.3), 
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- MODAL HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] ?? 'Material',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white54),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Colors.white24, thickness: 1),
                  ),

                  // --- Body of details ---
                  _buildDetailRow(Icons.category, 'Categoría', item['category'] ?? 'N/A'),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.straighten, item['unit_measurement'] ?? 'Unidad', item['quantity']?.toString() ?? 'N/A'),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.notes, 'Descripción', item['description'] ?? 'Sin descripción extra'),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.calendar_today, 'Añadido', formatSupabaseDate(item['created_at'] ?? 'N/A')),

                  const SizedBox(height: 20),
                  
                  // --- FOOTER DEL MODAL ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF40E0D0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.person, color: Color(0xFF40E0D0), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Añadido por: GVAF',
                          style: TextStyle(
                            color: Color(0xFF40E0D0),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDetailRow(IconData icon, String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: Colors.amber, size: 20),
      const SizedBox(width: 12),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 15, color: Colors.white),
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ),
    ],
  );
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
              categoryColor: _getCategoryColor(item['category']),
              onEdit: () => editItem(item),
              onMore: () => moreItem(context, item),
            );
          },
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'herramienta':
        return Color(0xFFFF0004);
      case 'fontanería':
        return Color(0xFF36BCFF);
      case 'electricidad':
        return Color(0xFFFFEA00);
      case 'material':
        return Color(0xFFC1C1C1);
      default:
        return Colors.teal; 
    }
  }
}