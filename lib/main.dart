import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyC86oUGJKS0dZw6kvEJrsMVmXN-XkF1GNA",
  authDomain: "flash-3481d.firebaseapp.com",
  projectId: "flash-3481d",
  storageBucket: "flash-3481d.firebasestorage.app",
  messagingSenderId: "684343480156",
  appId: "1:684343480156:web:64502f179201b068523b99"),
  );
  runApp(FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcards App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}