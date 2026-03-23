import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// * LAYOUTS
import '../layout/inventory_footer.dart';

class MainLayout extends StatefulWidget {
  final Widget child; 

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  
  void _showAddProjectForm() {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true, // : Allows the modal to take more space
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7, //: 70% of screen height
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
                'Add New Project',
                style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24.0),
              
              // --- Here go your form fields ---
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Project Name',
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
                  onPressed: () {
                    Navigator.pop(context); // : Close the modal
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text('Add Project', style: TextStyle(color: Colors.black)),
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