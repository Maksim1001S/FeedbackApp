import 'package:complete/feedback_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final DatabaseReference _messageRef =
      FirebaseDatabase.instance.ref("feedbacks");
  double _rating = 0;
  bool selected_raiting = false;

  void _sendMessage() async {
    String messageText = _messageController.text;
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName;
    print(userName);
    if (messageText.isNotEmpty && userName != null && selected_raiting) {
      if (user != null) {
        final userId = user.uid;
        var newMessageRef = _messageRef.push();
        await newMessageRef.set({
          'message': messageText,
          'rating': _rating,
          'timestamp': ServerValue.timestamp,
          'userName': userName,
          'userId': userId,
        });
        _messageController.clear();
        setState(() {
          _rating = 0;
          selected_raiting = false;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text(
                'You must have a username added to your personal account. Also, all fields are required and do not forget to rate the task on a 5-point scale.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              Expanded(
                child: FeedbackListScreen(),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter your Feedback',
                        ),
                        onSubmitted: (text) => _sendMessage(),
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: _rating,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          case 4:
                            return Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            );
                          default:
                            return Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                        }
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                          selected_raiting = true;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton.icon(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                        label: Text('Send'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _taskController.dispose();
    super.dispose();
  }
}
