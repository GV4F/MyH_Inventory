import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// * LAYOUTS
import '../layout/inventory_footer.dart';

class MainLayout extends StatefulWidget {
  final Widget child; 

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _nameProject = TextEditingController();
  final TextEditingController _categoryProject = TextEditingController();
  final TextEditingController _descriptionProject = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameProject.dispose();
    _categoryProject.dispose();
    _descriptionProject.dispose();
    super.dispose();
  }

  Future<void> _pushData() async {
    setState(() { _isSaving = true; });
    try {
      final name = _nameProject.text.trim();
      final category = _categoryProject.text.trim();
      final description = _descriptionProject.text.trim();

      if (name.isEmpty || category.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, completa todos los campos.', style: TextStyle(color: Colors.redAccent)),
          )
        );
        return;
      }
      
      await _supabase.from('locations').insert({
        'name': name,
        'category': category,
        'description': description,
      });

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proyecto aportado exitosamente!'))
        );
      }

    } catch (e) {
      print('Error inserting data: $e');
    } finally {
      if(mounted) {
        setState(() { _isSaving = false; });
        Navigator.pop(context);
      }
    }
  }
  
  void _showAddProjectForm() {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true, // : Allows the modal to take more space
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9, //: 90% of screen height
          decoration: const BoxDecoration(
            color: Color(0xFF151515),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Añadir nuevo Proyecto',
                style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24.0),
              
              // --- Here go your form fields ---
              TextField(
                controller: _nameProject,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _categoryProject,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionProject,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                ),
              ),

              const Spacer(), // : Pushes the button to the bottom

              // : Button to submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _pushData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text('Añadir', style: TextStyle(color: Colors.black)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x12121212),
      body: widget.child,
      
      bottomNavigationBar: InventoryFooter(
        onHomeTap: () => context.go('/'),
        onAddProjectTap: () {
          _showAddProjectForm();
        },
        onUserTap: () => context.go('/profile'),
      ),
    );
  }
}