import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  List<Map<String, dynamic>> _jobs = [];
  String _searchQuery = ''; // For search functionality

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  // Fetch jobs from Firestore
  Future<void> _fetchJobs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('jobs').get();

      setState(() {
        _jobs = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching jobs: $e')));
    }
  }

  // Save job to the savedJobs collection in Firestore
  Future<void> _saveJob(Map<String, dynamic> job) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('savedJobs').add({
        'userId': user.uid,
        'jobId': job['jobId'], // assuming job document has jobId
        'position': job['position'],
        'requirements': job['requirements'],
        'location': job['location'],
        'contactDetails': job['contactDetails'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job saved')));
    }
  }

  // Filter jobs based on the search query
  List<Map<String, dynamic>> _filterJobs() {
    if (_searchQuery.isEmpty) {
      return _jobs;
    }
    return _jobs.where((job) {
      return job['position'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job['requirements'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job['location'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Search'),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Jobs',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value; // Update search query
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filterJobs().length,
                    itemBuilder: (context, index) {
                      var job = _filterJobs()[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        child: ListTile(
                          title: Text(
                            job['position'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${job['requirements']} \nLocation: ${job['location']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite_outline), // Changed to heart icon
                            onPressed: () => _saveJob(job), // Save job when icon is pressed
                            color: Colors.teal, // Icon color
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}