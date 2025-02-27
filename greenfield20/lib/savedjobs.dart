import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  _SavedJobsScreenState createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  List<Map<String, dynamic>> _savedJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedJobs();
  }

  // Fetch saved jobs from Firestore
  Future<void> _fetchSavedJobs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('savedJobs')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        _savedJobs = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching saved jobs: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        backgroundColor:  const Color.fromARGB(151, 62, 162, 165),

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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _savedJobs.isEmpty
                  ? const Center(child: Text('No saved jobs found.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))
                  : ListView.builder(
                      itemCount: _savedJobs.length,
                      itemBuilder: (context, index) {
                        var job = _savedJobs[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5, // Add shadow for elevation
                          child: ListTile(
                            title: Text(
                              job['position'],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job['requirements'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Location: ${job['location']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Contact:',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  job['contactDetails'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}