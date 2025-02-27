import 'package:flutter/material.dart';
import 'package:greenfield20/jobsearch.dart';
import 'package:greenfield20/profile.dart';
import 'package:greenfield20/savedjobs.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/A_sleek_and_modern_abstract_illustration_suitable_.png.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // Overlay for readability
          ),
          // Menu content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 40), // Space at the top
                    // Image/logo container
                    Container(
                      width: 220,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/menu.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Profile Button
                    MenuButton(
                      text: 'Profile',
                      icon: Icons.person,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Saved Jobs Button
                    MenuButton(
                    
                      text: 'Saved Jobs',
                      icon: Icons.bookmark,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SavedJobsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Search Jobs Button
                    MenuButton(
                      text: 'Search Jobs',
                      icon: Icons.search,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const JobSearchScreen()),
                        );
                      },
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

// Custom Widget for Menu Buttons
class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: onPressed,
        leading: Icon(
          icon,
          color: const Color(0xFF00ACC1),
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF00ACC1)),
      ),
    );
  }
}