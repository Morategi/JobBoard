import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenfield20/menu.dart'; // Job Seeker Menu
import 'package:greenfield20/recruiterMenu.dart'; // Recruiter Menu
import 'package:greenfield20/signin.dart'; // Sign-in page

enum UserType { recruiter, jobSeeker }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCdLXHOC56xBEPGbhX9UA3tbRjP0xmhYFg",
      authDomain: "greenfields-app.firebaseapp.com",
      projectId: "greenfields-app",
      storageBucket: "greenfields-app.appspot.com",
      messagingSenderId: "18694681335",
      appId: "1:18694681335:web:af3b811b20ea8ccb79d9f2",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = '';
  UserType _selectedUserType = UserType.jobSeeker; // Default selection

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _validatePassword(String value) {
    String pattern = r'^(?=.*[A-Z]).{6,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        String uid = userCredential.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'username': _username,
          'email': _email,
          'userType': _selectedUserType == UserType.jobSeeker ? 'jobSeeker' : 'recruiter',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );

        if (_selectedUserType == UserType.jobSeeker) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuPage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecruiterApp()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
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
          Container(
            color: Colors.black.withOpacity(0.3), // Overlay for better readability
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 60),
                  const Text(
                    'Welcome to GreenFields',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Where your career awaits.\nLet us help you in landing a dream job!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your personal information is protected under the POPI Act, and we ensure it is handled securely and only used for its intended purpose.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  
                      const Text('Already have an account?', style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInPage()),
                          );
                        },
                        child: const Text('Sign in', style: TextStyle(color: Color(0xFF00ACC1))),
                      ),
                    
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: const Icon(Icons.person),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _username = value ?? '';
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!EmailValidator.validate(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value ?? '';
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (!_validatePassword(value)) {
                                  return 'Password must be at least 6 characters long and contain one capital letter';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value ?? '';
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text('Are you a Recruiter or a Job Seeker?'),
                            RadioListTile<UserType>(
                              title: const Text('Job Seeker'),
                              value: UserType.jobSeeker,
                              groupValue: _selectedUserType,
                              onChanged: (UserType? value) {
                                setState(() {
                                  _selectedUserType = value!;
                                });
                              },
                            ),
                            RadioListTile<UserType>(
                              title: const Text('Recruiter'),
                              value: UserType.recruiter,
                              groupValue: _selectedUserType,
                              onChanged: (UserType? value) {
                                setState(() {
                                  _selectedUserType = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00ACC1),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 15,
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                              ),
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?', style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInPage()),
                          );
                        },
                        child: const Text('Sign in', style: TextStyle(color: Color(0xFF00ACC1))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}