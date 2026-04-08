import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoveItemModal extends StatefulWidget {
  final Map<String, dynamic> item;
  final String currentProjectId;
  final List<dynamic> projects;

  const MoveItemModal({
    super.key,
    required this.item,
    required this.currentProjectId,
    required this.projects,
  });

  @override
  State<MoveItemModal> createState() => _MoveItemModalState();
}

class _MoveItemModalState extends State<MoveItemModal> {
  String? _selectedProjectId;
  late int  _amountToMove;
  late int _maxAmount;
  final TextEditingController _justificationController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _maxAmount = widget.item['quantity'] ?? 0;
    _amountToMove = 1; 
  }

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  void _incrementar() {
    if (_amountToMove < _maxAmount) {
      setState(() => _amountToMove++);
    }
  }

  void _decrementar() {
    if (_amountToMove > 1) {
      setState(() => _amountToMove--);
    }
  }

  Future<void> moveMaterial({
    required Map<String, dynamic> itemActual,
    required String idProyectoDestino,
    required int amountToMove,
    required String justificacion,
  })

  async {
    final supabase = Supabase.instance.client;
    final int actualAmount = itemActual['quantity'];
    final String idActualItem = itemActual['id'];

    try {
      // - Scenery A: Total movement
      if (amountToMove == actualAmount) {
        await supabase.from('products').update({
          'id_location': idProyectoDestino,
        }).eq('id', idActualItem);
        await supabase.from('movements').insert({
          'id_product': idActualItem,
          'from_location': widget.currentProjectId,
          'to_location': idProyectoDestino,
          'quantity': amountToMove,
          'justification': justificacion,
        });
        
      } 
      // - Scenery B: Partial movement
      else if (amountToMove > 0 && amountToMove < actualAmount) {
        // : 1. Clone the original item with the new values for the destination
        final Map<String, dynamic> nuevoItem = Map<String, dynamic>.from(itemActual);
        
        // : Clean up fields that shouldn't be duplicated
        nuevoItem.remove('id'); 
        nuevoItem.remove('created_at');
        
        // : Set the new values for the cloned item
        nuevoItem['id_location'] = idProyectoDestino;
        nuevoItem['quantity'] = amountToMove;

        // - 2. Execute both operations in a transaction-like manner
        // : Use the future returned by the insert to get the new item's ID for the movement record
        await Future.wait([
          supabase.from('products').update({
            'quantity': actualAmount - amountToMove
          }).eq('id', idActualItem),
          
          // : We insert the new item and then use its ID for the movement record
          supabase.from('products').insert(nuevoItem),
        ]);
      }

    } catch (e) {
      print('Error crítico moviendo material: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final destinationProject = widget.projects
        .where((p) => p['id'].toString() != widget.currentProjectId)
        .toList();

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
              color: const Color(0xFF151515).withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFCCC3E).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Tittle ---
                  Text(
                    '${widget.item['name']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- 1. Dropdown Destiny ---
                  const Text('Proyecto Destino', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedProjectId,
                    dropdownColor: const Color(0xFF212121),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF212121),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    hint: const Text('Selecciona un destino...', style: TextStyle(color: Colors.white38)),
                    items: destinationProject.map((p) {
                      return DropdownMenuItem<String>(
                        value: p['id'].toString(),
                        child: Text(p['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedProjectId = val),
                  ),
                  const SizedBox(height: 20),

                  // --- 2. Amount Selector ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cantidad a mover:', style: TextStyle(color: Colors.white70)),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF212121),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.amber),
                              onPressed: _decrementar,
                            ),
                            Text(
                              '$_amountToMove / $_maxAmount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.amber),
                              onPressed: _incrementar,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- 3. Justification ---
                  const Text('Justificación', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _justificationController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ej. Traslado temporal por falta de material...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF212121),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- 4. Action buttons ---
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_selectedProjectId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Por favor selecciona un destino')),
                              );
                              return;
                            }
                            if (_justificationController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('La justificación es obligatoria')),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            await moveMaterial(
                              itemActual: widget.item,
                              idProyectoDestino: _selectedProjectId!,
                              amountToMove: _amountToMove,
                              justificacion: _justificationController.text.trim(),
                            );
                            
                            if (mounted) {
                              setState(() => _isLoading = false);
                              Navigator.pop(context);
                            }
                          },
                          child: _isLoading 
                            ? const SizedBox(
                                height: 20, 
                                width: 20, 
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)
                              )
                            : const Text('Mover', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}