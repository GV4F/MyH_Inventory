import 'package:flutter/material.dart';
import 'package:myh_inventory/auth/auth_sevice.dart';

enum AuthTab { login, register }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthTab _currentState = AuthTab.login;
  FocusNode _userFocus = FocusNode();

  @override
  void dispose() {
    _userFocus.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onTabChanged(AuthTab newTab) {
    setState(() {
      _currentState = newTab;
    });
  }

  // - Create a new user account
  Future<void> _signUp() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signUp(username, email, password);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado exitosamente!')),
        );
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // - Sign in an existing user
  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signIn(email, password);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso!')),
        );
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return FractionallySizedBox(
      heightFactor: 0.9,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40.0),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.primary,
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            )]
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // : 1. Tab selector (Login / Register)
              Container(
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF212121),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white10,
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment: _currentState == AuthTab.login
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        heightFactor: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.secondary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    // : 2. Text (static labels)
                    Positioned.fill(
                      child: Row(
                        children: [
                          // : Log in (left)
                          Expanded(
                            child: InkWell(
                              onTap: () => _onTabChanged(AuthTab.login),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Ingresar',
                                  style: TextStyle(
                                    color: _currentState == AuthTab.login
                                        ? Colors.white
                                        : Colors.white54,
                                    fontSize: 18,
                                    fontWeight: _currentState == AuthTab.login
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Pestaña 'Crear Cuenta' (Derecha)
                          Expanded(
                            child: InkWell(
                              onTap: () => _onTabChanged(AuthTab.register),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Crear Cuenta',
                                  style: TextStyle(
                                    color: _currentState == AuthTab.register
                                        ? Colors.white
                                        : Colors.white54, // Texto dimmer si inactivo
                                    fontSize: 18,
                                    fontWeight: _currentState == AuthTab.register
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // : 3. Form fields
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A), 
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // : USERNAME
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(color: colors.tertiary),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusColor: colors.primary,
                        labelText: 'Nombre de usuario',
                        labelStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.person_outline, color: colors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // : EMAIL
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: colors.tertiary),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusColor: colors.primary,
                        labelText: 'Correo electrónico',
                        labelStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.email_outlined, color: colors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // : PASSWORD
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(color: colors.tertiary),
                      obscureText: true,
                      decoration: InputDecoration(
                        focusColor: colors.primary,
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.lock_outline, color: colors.primary),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}