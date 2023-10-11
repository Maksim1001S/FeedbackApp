import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({Key? key}) : super(key: key);

  @override
  _FeedbackListScreenState createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  late DatabaseReference _feedbacksRef;
  List<FeedbackData> _feedbacks = [];

  @override
  void initState() {
    super.initState();
    _feedbacksRef = FirebaseDatabase.instance.ref("feedbacks");

    _feedbacksRef.onChildAdded.listen((DatabaseEvent event) {
      setState(() {
        _feedbacks.add(FeedbackData.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _feedbacks.isEmpty
          ? Center(child: Text('Нет доступных фидбеков.'))
          : Center(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: _feedbacks.map((feedback) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(feedback.userName),
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Text('Message: ${feedback.message}'),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: RatingBar.builder(
                                        initialRating: feedback.rating,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return Icon(
                                                Icons
                                                    .sentiment_very_dissatisfied,
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
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class FeedbackData {
  final String userName;
  final String message;
  final double rating;

  FeedbackData({
    required this.userName,
    required this.message,
    required this.rating,
  });

  factory FeedbackData.fromSnapshot(DataSnapshot snapshot) {
    final dynamic json = snapshot.value;
    if (json is Map<dynamic, dynamic>) {
      return FeedbackData(
        message: json['message'],
        userName: json['userName'],
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );
    } else {
      // Возвращаем FeedbackData с пустыми данными, если json не является Map
      return FeedbackData(
        message: '',
        userName: '',
        rating: 0.0,
      );
    }
  }
}
