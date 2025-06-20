import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/login_page.dart';
import 'home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDeNmIidsd8PoP8uxoOVjiUahRfv3gBC2c",
        authDomain: "flahcard-9770c.firebaseapp.com",
        projectId: "flahcard-9770c",
        storageBucket: "flahcard-9770c.firebasestorage.app",
        messagingSenderId: "990517797033",
        appId: "1:990517797033:web:c5c39d3da9b2b2882309b8"),
  );

  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}
