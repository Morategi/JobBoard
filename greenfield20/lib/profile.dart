import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for various fields
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _idController = TextEditingController();
  final _ageController = TextEditingController();
  final _cellController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _languagesController = TextEditingController();

  // Skills List
  final Map<String, bool> _skills = {
    'Communication': false,
    'Teamwork': false,
    'Problem Solving': false,
    'Leadership': false,
    'Time Management': false,
    'Painter': false,
    'Gardener': false,
    'Baby Sitter': false,
  };

  // List for dynamic education and references
  final List<TextEditingController> _educationControllers = [TextEditingController()];
  final List<TextEditingController> _referenceControllers = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Add new field for education or references
  void _addNewEducationField() {
    setState(() {
      _educationControllers.add(TextEditingController());
    });
  }

  void _addNewReferenceField() {
    setState(() {
      _referenceControllers.add(TextEditingController());
    });
  }

  // Save profile data to Firestore
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user logged in')));
        return;
      }

      // Prepare education and references data
      List<String> educationList = _educationControllers.map((controller) => controller.text).toList();
      List<String> referenceList = _referenceControllers.map((controller) => controller.text).toList();

      // Save profile data to Firestore
      await FirebaseFirestore.instance.collection('profiles').doc(user.uid).set({
        'name': _nameController.text,
        'surname': _surnameController.text,
        'id': _idController.text,
        'age': _ageController.text,
        'cell': _cellController.text,
        'hobbies': _hobbiesController.text,
        'languages': _languagesController.text,
        'skills': _skills,
        'education': educationList,
        'references': referenceList,
        'userId': user.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save profile: $e')));
    }
  }

  Future<void> _loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance.collection('profiles').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _surnameController.text = data['surname'] ?? '';
          _idController.text = data['id'] ?? '';
          _ageController.text = data['age'] ?? '';
          _cellController.text = data['cell'] ?? '';
          _hobbiesController.text = data['hobbies'] ?? '';
          _languagesController.text = data['languages'] ?? '';
          _skills.forEach((key, value) {
            _skills[key] = data['skills'][key] ?? false;
          });
          _educationControllers.clear();
          _educationControllers.addAll(
            (data['education'] as List<dynamic>? ?? []).map((e) => TextEditingController(text: e.toString())),
          );
          _referenceControllers.clear();
          _referenceControllers.addAll(
            (data['references'] as List<dynamic>? ?? []).map((e) => TextEditingController(text: e.toString())),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(151, 62, 162, 165),
        title: const Text('Create Profile'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/A_sleek_and_modern_abstract_illustration_suitable_.png.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Icon at the top
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Surname Field
                    TextFormField(
                      controller: _surnameController,
                      decoration: const InputDecoration(labelText: 'Surname'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your surname';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // ID Field
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(labelText: 'ID Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Age Field
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Cell Number with Validation
                    TextFormField(
                      controller: _cellController,
                      decoration: const InputDecoration(labelText: 'Cell Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your cell number';
                        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Education Fields (Dynamic)
                    const Text('Education', style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      children: _educationControllers.map((controller) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(labelText: 'Education'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your education';
                              }
                              return null;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    TextButton(
                      onPressed: _addNewEducationField,
                      child: const Text('Add More Education'),
                    ),

                    const SizedBox(height: 10),

                    // Hobbies Field
                    TextFormField(
                      controller: _hobbiesController,
                      decoration: const InputDecoration(labelText: 'Hobbies'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your hobbies';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Languages Field
                    TextFormField(
                      controller: _languagesController,
                      decoration: const InputDecoration(labelText: 'Languages'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the languages you speak';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // References Fields (Dynamic)
                    const Text('References', style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      children: _referenceControllers.map((controller) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(labelText: 'Reference'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a reference';
                              }
                              return null;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    TextButton(
                      onPressed: _addNewReferenceField,
                      child: const Text('Add More References'),
                    ),

                    const SizedBox(height: 10),

                    // Skills Checklist
                    const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      children: _skills.keys.map((String key) {
                        return CheckboxListTile(
                          title: Text(key),
                          value: _skills[key],
                          onChanged: (bool? value) {
                            setState(() {
                              _skills[key] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('Save Profile'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}