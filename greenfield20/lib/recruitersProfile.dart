import 'package:flutter/material.dart';

class RecruiterProfileScreen extends StatefulWidget {
  const RecruiterProfileScreen({super.key});

  @override
  _RecruiterProfileScreenState createState() => _RecruiterProfileScreenState();
}

class _RecruiterProfileScreenState extends State<RecruiterProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Function to validate and save the profile
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save profile to Firebase or another backend service
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recruiter Profile'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextField(controller: _nameController, label: 'Name', validator: _validateName),
              const SizedBox(height: 16),
              _buildTextField(controller: _surnameController, label: 'Surname', validator: _validateName),
              const SizedBox(height: 16),
              _buildTextField(controller: _idController, label: 'ID Number', validator: _validateId),
              const SizedBox(height: 16),
              _buildTextField(controller: _addressController, label: 'Address', validator: _validateNotEmpty),
              const SizedBox(height: 16),
              _buildTextField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress, validator: _validateEmail),
              const SizedBox(height: 16),
              _buildTextField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone, validator: _validatePhone),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a text field with validation
  Widget _buildTextField({required TextEditingController controller, required String label, TextInputType keyboardType = TextInputType.text, required String? Function(String?) validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  // Validators
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validateId(String? value) {
    if (value == null || value.length != 13) {
      return 'Please enter a valid 13-digit ID number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.length < 10 || !RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }
}