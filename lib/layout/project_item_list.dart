import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'project_item.dart'; 
import 'dart:async';
// * Modals
import 'modal_edit.dart';
import 'modal_more.dart';

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

  // - ON MORE
  void moreItem(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MoreModal(item: item);
      },
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
      case 'maquinaria':
        return Color(0xFF3A0066);
      default:
        return Colors.teal; 
    }
  }
}