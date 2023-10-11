import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBpQoPOBbiGqn7XmdQSIw2j-nJOUdCYedU",
          authDomain: "feedback-app-a488f.firebaseapp.com",
          databaseURL:
              "https://feedback-app-a488f-default-rtdb.europe-west1.firebasedatabase.app",
          projectId: "feedback-app-a488f",
          storageBucket: "feedback-app-a488f.appspot.com",
          messagingSenderId: "1056355062042",
          appId: "1:1056355062042:web:c7bc80932367aef9ae1ca3",
          measurementId: "G-GYKJP03751"));

  runApp(const MyApp());
}
