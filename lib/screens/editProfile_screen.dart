import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminari_flutter/provider/users_provider.dart';
import 'package:seminari_flutter/widgets/Layout.dart';
import '../models/user.dart';

class EditprofileScreen extends StatefulWidget {
  const EditprofileScreen({super.key});

  @override
  State<EditprofileScreen> createState() => _CambiosScreenState();
}

class _CambiosScreenState extends State<EditprofileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _edatController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).registeredUser;
    
    _nomController = TextEditingController(text: user?.name ?? '');
    _edatController = TextEditingController(text: user?.age?.toString() ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _edatController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _guardarCanvis() async {
  if (_formKey.currentState!.validate()) {
    final provider = Provider.of<UserProvider>(context, listen: false);

    await provider.editarUsuari(
      User(
        id: provider.registeredUser!.id,
        name: _nomController.text,
        age: _edatController.text.isNotEmpty ? int.parse(_edatController.text) : 0,
        email: _emailController.text,
        password: provider.registeredUser!.password,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Canvis guardats correctament!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    Navigator.of(context).pop();
  }
}


  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      title: 'Editar Perfil',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    color: Colors.deepPurple[100],
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 36, color: Colors.deepPurple),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Edita el teu perfil',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.deepPurple[900],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildFormField(
                              controller: _nomController,
                              label: 'Nom',
                              icon: Icons.person,
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Cal omplir el nom'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildFormField(
                              controller: _edatController,
                              label: 'Edat',
                              icon: Icons.cake,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cal omplir l\'edat';
                                }
                                final age = int.tryParse(value);
                                if (age == null || age < 0) {
                                  return 'Insereix una edat vàlida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildFormField(
                              controller: _emailController,
                              label: 'Correu electrònic',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cal omplir el correu';
                                }
                                if (!value.contains('@')) {
                                  return 'Adreça electrònica no vàlida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: _guardarCanvis,
                              icon: const Icon(Icons.save),
                              label: const Text(
                                'GUARDAR CANVIS',
                                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

    Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(221, 0, 0, 0), 
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: Colors.deepPurple), 
        filled: true,
        fillColor: Colors.white, 
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 224, 224, 224), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2), 
        ),
      ),
      style: const TextStyle( 
      color: Colors.black, 
      fontSize: 16,
    ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}