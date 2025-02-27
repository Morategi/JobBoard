import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fetch messages from Firestore
  Future<void> _fetchMessages() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('messages')
          .where('receiverId', isEqualTo: user.uid) // Ensure this matches your Firestore field
          .get();

      setState(() {
        _messages = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id, // Get the document ID for later use
            'title': data['title'], // Ensure these fields exist in your Firestore documents
            'content': data['message'], // Change to the correct field name for the message
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching messages: $e')));
    }
  }

  // Accept the offer
  void _acceptOffer(String messageId) {
    FirebaseFirestore.instance.collection('messages').doc(messageId).update({'status': 'accepted'});
    _fetchMessages(); // Refresh the messages
  }

  // Reject the offer
  void _rejectOffer(String messageId) {
    FirebaseFirestore.instance.collection('messages').doc(messageId).update({'status': 'rejected'});
    _fetchMessages(); // Refresh the messages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: Stack(
        children: [
           Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Turquoise_watercolor_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              var message = _messages[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(message['title'] ?? 'No Title'), // Default value if title is null
                  subtitle: Text(message['content'] ?? 'No Content'), // Default value if content is null
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () => _acceptOffer(message['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _rejectOffer(message['id']),
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