import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

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
    setState(() {
      _amount--;
      _amountController.text = _amount.toString();
    });
  }

  void _increase() {
    if (_amount == 0) return;
    setState(() {
      _amount++;
      _amountController.text = _amount.toString();
    });
  }


  @override
  Widget build(BuildContext context) {

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
                      const Text('Modificar:', style: TextStyle(color: Colors.white70)),
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