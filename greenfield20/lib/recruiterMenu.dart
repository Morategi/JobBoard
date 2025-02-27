import 'package:flutter/material.dart';
import 'package:greenfield20/postJobs.dart';
import 'package:greenfield20/recruitersProfile.dart';
import 'package:greenfield20/searchProfiles.dart';


class RecruiterApp extends StatelessWidget {
  const RecruiterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recruiter App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const RecruiterDashboard(),
    );
  }
}

class RecruiterDashboard extends StatelessWidget {
  const RecruiterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/A_sleek_and_modern_abstract_illustration_suitable_.png.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 100),
                _buildMenuButton(
                  context,
                  icon: Icons.post_add,
                  label: 'Post Jobs',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostJobScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  icon: Icons.search,
                  label: 'View Profiles',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchProfilesScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  icon: Icons.person,
                  label: 'Create Profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RecruiterProfileScreen()),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 30),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20), // Increase vertical padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
          ),
        ),
      ),
    );
  }
}