import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoreModal extends StatefulWidget {
  final Map<String, dynamic> item;
  const MoreModal({
      super.key, 
      required this.item
    });

  @override
  State<MoreModal> createState() => _MoreModalState();
}

class _MoreModalState extends State<MoreModal> {

  final TextEditingController _amountController = TextEditingController();
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.item['quantity'] ?? 0;
    _amountController.text = _amount.toString();
  }

  String formatSupabaseDate(String dateString) {
    DateTime date = DateTime.parse(dateString);

    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _decrease() {
    if (_amount == 0) return;
    setState(() {
      _amount--;
      _amountController.text = _amount.toString();
    });
  }

  void _increase() {
    setState(() {
      _amount++;
      _amountController.text = _amount.toString();
    });
  }

  Future<void> _updateQuantity({
    required int amount,
    required Map<String, dynamic> item,
  }) async {
     
    final supabase = Supabase.instance.client;
     
    try {
      if(amount == 0) {
      await supabase.from('products').delete().eq('id', item['id']);
     } else {
      await supabase.from('products').update({'quantity': amount}).eq('id', item['id']);
     }
    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar cantidad: $e'))
        );
      }
    }
  }

  Future<String> _getNameofUser() async {
    final supabase = Supabase.instance.client;
    try {
      final data = await supabase.from('profiles').select('username').eq('id', widget.item['id_user']).single();
      return data['username'] ?? 'Usuario desconocido';
    } catch(e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

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
                color: const Color(0xFF151515).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFCCC3E).withValues(alpha: 0.3), 
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
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
                          widget.item['name'] ?? 'Material',
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
                  _buildDetailRow(Icons.category, 'Categoría', widget.item['category'] ?? 'N/A'),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.straighten, widget.item['unit_measurement'] ?? 'Unidad', widget.item['quantity']?.toString() ?? 'N/A'),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.notes, 'Descripción', widget.item['description'] ?? 'Sin descripción extra'),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.calendar_today, 'Añadido', formatSupabaseDate(widget.item['created_at'] ?? 'N/A')),

                  const SizedBox(height: 20),

                  // --- Modify Amount Button ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.surface,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            if(_amount == widget.item['quantity']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No se realizaron cambios'))
                              );
                              return;
                            }
                            if(_amount != widget.item['quantity']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Cantidad modificada a $_amount'))
                              );
                            }
                            if(_amount == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Producto eliminado del inventario'))
                              );
                            }
                            _updateQuantity(
                              amount: _amount,
                              item: widget.item,
                            );
                          },
                          child: const Text('Modificar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        )
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF212121),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.amber),
                              onPressed: _decrease,
                            ),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  suffixStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                                ),
                                onChanged: (value) {
                                  int val = int.tryParse(value) ?? 0;
                                  setState(() => _amount = val);
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.amber),
                              onPressed: _increase,
                            ),
                          ],
                        )
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // --- FOOTER DEL MODAL ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF40E0D0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, color: Color(0xFF40E0D0), size: 16),
                        SizedBox(width: 8),
                        FutureBuilder<String>(
                          future: _getNameofUser(),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return const Text(
                                'Cargando...', 
                                style: TextStyle(color: Color(0xFF40E0D0), 
                                fontStyle: FontStyle.italic, fontSize: 14)
                              );
                            }
                            
                            if(snapshot.hasError) {
                              return const Text(
                                'Error al cargar usuario',
                                style: TextStyle(color: Color(0xFFE04075), fontStyle: FontStyle.italic, fontSize: 14)
                              );
                            }
                            return Text(
                              'Añadido por: ${snapshot.data ?? 'Usuario desconocido'}',
                              style: const TextStyle(
                                color: Color(0xFF40E0D0),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            );
                          },
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
  }
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