import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final TextEditingController positionController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactDetailsController = TextEditingController();

  // Function to post the job
  Future<void> postJob() async {
    if (positionController.text.isNotEmpty &&
        requirementsController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        contactDetailsController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('jobs').add({
        'position': positionController.text,
        'requirements': requirementsController.text,
        'location': locationController.text,
        'contactDetails': contactDetailsController.text,
        'timestamp': FieldValue.serverTimestamp(), // To keep track of post time
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job posted successfully')));
      positionController.clear();
      requirementsController.clear();
      locationController.clear();
      contactDetailsController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
    }
  }

  // Function to delete a job from both 'jobs' and 'savedJobs'
  Future<void> deleteJob(String jobId) async {
    try {
      // Delete from the 'jobs' collection
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();

      // Delete from the 'savedJobs' of the recruiter or any other collection it might be in
      QuerySnapshot savedJobsSnapshot = await FirebaseFirestore.instance
          .collection('savedJobs')
          .where('jobId', isEqualTo: jobId)
          .get();

      for (var doc in savedJobsSnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error deleting the job')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Jobs'),
        backgroundColor: const Color.fromARGB(151, 62, 162, 165),
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
              children: <Widget>[
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                  ),
                ),
                TextField(
                  controller: requirementsController,
                  decoration: const InputDecoration(
                    labelText: 'Requirements',
                  ),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),
                ),
                TextField(
                  controller: contactDetailsController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Details',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: postJob,
                  child: const Text('Post Job'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Posted Jobs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('jobs')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No jobs posted yet.');
                      }

                      final jobDocs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: jobDocs.length,
                        itemBuilder: (context, index) {
                          final jobData = jobDocs[index].data() as Map<String, dynamic>;
                          final jobId = jobDocs[index].id;
                          return ListTile(
                            title: Text(jobData['position']),
                            subtitle: Text('Location: ${jobData['location']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteJob(jobId),
                            ),
                          );
                        },
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