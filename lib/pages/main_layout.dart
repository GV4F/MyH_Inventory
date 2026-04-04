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
  //: Controllers for the "Add Project" form
  final TextEditingController _nameProject = TextEditingController();
  final TextEditingController _categoryProject = TextEditingController();
  final TextEditingController _descriptionProject = TextEditingController();
  //: Controllers for the "Add Object" form
  final TextEditingController _nameObject = TextEditingController();
  final TextEditingController _categoryObject = TextEditingController();
  final TextEditingController _unitMeasurement = TextEditingController();
  final TextEditingController _quantityObject = TextEditingController();
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
  
  Future <void> _pushDataObject({required String projectId}) async {
    setState(() { _isSaving = true; });
    try {
      final name = _nameObject.text.trim();
      final category = _categoryObject.text.trim();
      final unitMeasurement = _unitMeasurement.text.trim();
      final quantity = int.tryParse(_quantityObject.text.trim()) ?? 0;

      if (name.isEmpty || category.isEmpty || unitMeasurement.isEmpty || quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, completa todos los campos correctamente.', style: TextStyle(color: Colors.redAccent)),
          )
        );
        return;
      }
      
      await _supabase.from('products').insert({
        'name': name,
        'category': category,
        'unit_measurement': unitMeasurement,
        'quantity': quantity,
        'id_location': projectId,
      });

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Objeto aportado exitosamente!'))
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

  void _showAddItemModal(BuildContext context, String projectId) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
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
                'Añadir Objeto',
                style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24.0),
              // - Form fields for adding an item would go here, similar to the project form
              // : Object Name Field
              TextField(
                controller: _nameObject,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nombre del Objeto',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                ),
              ),
              SizedBox(height: 16.0),
              // : Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _categoryObject.text.isEmpty ? null : _categoryObject.text,
                items: ['Herramienta', 'Material', 'Fontanería', 'Electricidad', 'Maquinaria'].map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryObject.text = value ?? '';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                ),
              ),
              SizedBox(height: 16.0),
              // : Unit of Measurement Dropdown
              DropdownButtonFormField<String>(
                initialValue: _unitMeasurement.text.isEmpty ? null : _unitMeasurement.text,
                items: ['Metro Cúbico', 'Metro Cuadrado', 'Unidad', 'Ciento', 'Libra', 'Quintal', 'Otra'].map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _unitMeasurement.text = value ?? '';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Unidad de Medida',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                ),
              ),
              SizedBox(height: 16.0),
              // : Quantity Field
              TextField(
                controller: _quantityObject,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Cantidad',
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
                  onPressed: _isSaving ? null : () => _pushDataObject(projectId: projectId),
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
          final String location = GoRouterState.of(context).uri.path;
          if(location == '/') {
            _showAddProjectForm();
          } 
          else if (location.startsWith('/project/')) {
            final projectId = location.split('/').last;
            _showAddItemModal(context, projectId);
          }
        },
        onUserTap: () => context.go('/profile'),
      ),
    );
  }
}