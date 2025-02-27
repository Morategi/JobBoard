import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchProfilesScreen extends StatefulWidget {
  const SearchProfilesScreen({super.key});

  @override
  _SearchProfilesScreenState createState() => _SearchProfilesScreenState();
}

class _SearchProfilesScreenState extends State<SearchProfilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSkillSearch = false;

  // Search function based on username or skills
  void _searchProfiles() async {
    String searchTerm = _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      QuerySnapshot snapshot;

      if (_isSkillSearch) {
        // Search by skills
        snapshot = await FirebaseFirestore.instance
            .collection('profiles')
            .where('skills.$searchTerm', isEqualTo: true)
            .get();
      } else {
        // Search by username
        snapshot = await FirebaseFirestore.instance
            .collection('profiles')
            .where('name', isEqualTo: searchTerm)
            .get();
      }

      setState(() {
        _searchResults = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    }
  }

  // Navigate to profile view screen
  void _viewProfile(Map<String, dynamic> profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobSeekerProfileScreen(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Profiles'),
        backgroundColor: const Color.fromARGB(151, 62, 162, 165),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/A_sleek_and_modern_abstract_illustration_suitable_.png.jpg'),
            fit: BoxFit.cover, // Ensures the image covers the entire container
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchResults.clear();
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSkillSearch = false;
                      });
                      _searchProfiles();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(151, 62, 162, 165),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Search by Username'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSkillSearch = true;
                      });
                      _searchProfiles();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(151, 62, 162, 165),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Search by Skills'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    var profile = _searchResults[index];
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          profile['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _isSkillSearch
                              ? 'Skills: ${(profile['skills'] as Map).keys.where((key) => profile['skills'][key] == true).join(', ')}'
                              : 'Email: ${profile['email']}',
                        ),
                        onTap: () => _viewProfile(profile), // View profile on tap
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Read-only profile screen with messaging option
class JobSeekerProfileScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  const JobSeekerProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${profile['name']}\'s Profile'),
        backgroundColor: const Color.fromARGB(151, 62, 162, 165),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/A_sleek_and_modern_abstract_illustration_suitable_.png.jpg'),
            fit: BoxFit.cover, // Ensures the image covers the entire container
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name: ${profile['name']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Surname: ${profile['surname']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Email: ${profile['email']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Age: ${profile['age']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Cell Number: ${profile['cell']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Hobbies: ${profile['hobbies']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Languages: ${profile['languages']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Education: ${profile['education'].join(', ')}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('References: ${profile['references'].join(', ')}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Skills: ${(profile['skills'] as Map).keys.where((key) => profile['skills'][key] == true).join(', ')}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),

              // New Availability Display
              Text('Availability: ${profile['availability'] ?? "Not specified"}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              // New Like Profile Button
              ElevatedButton(
                onPressed: () {
                  _likeProfile(context, profile['id']); // Call the like function
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Like Profile'),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageScreen(jobSeekerId: profile['id']),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Consistent button color
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Message Job Seeker'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Like profile function
  void _likeProfile(BuildContext context, String jobSeekerId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Check if already liked
      final likesSnapshot = await FirebaseFirestore.instance
          .collection('likes')
          .where('jobSeekerId', isEqualTo: jobSeekerId)
          .where('recruiterId', isEqualTo: currentUserId)
          .get();

      if (likesSnapshot.docs.isEmpty) {
        // Add like if not already liked
        await FirebaseFirestore.instance.collection('likes').add({
          'jobSeekerId': jobSeekerId,
          'recruiterId': currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile liked!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You already liked this profile!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error liking profile.')));
    }
  }
}

// Messaging screen to send messages to job seekers
class MessageScreen extends StatefulWidget {
  final String jobSeekerId;
  const MessageScreen({super.key, required this.jobSeekerId});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<QueryDocumentSnapshot> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Function to fetch messages between sender and receiver
  Future<void> _fetchMessages() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('receiverId', isEqualTo: widget.jobSeekerId)
        .where('senderId', isEqualTo: currentUserId)
        .get();

    setState(() {
      _messages = snapshot.docs;
    });
  }

  // Function to send a message
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'receiverId': widget.jobSeekerId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(), // Keep timestamp for order but don't display
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message sent')));
      _messageController.clear();
      _fetchMessages(); // Refresh messages after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Job Seeker'),
        backgroundColor: const Color.fromARGB(151, 62, 162, 165),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/A_sleek_and_modern_abstract_illustration_suitable_.png.jpg'),
                fit: BoxFit.cover, // Ensures the image covers the entire container
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final messageData = _messages[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(messageData['message']),
                        // Removed timestamp display
                        tileColor: Colors.white.withOpacity(0.8), // Message background
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                        color: Colors.teal, // Consistent icon color
                      ),
                    ],
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