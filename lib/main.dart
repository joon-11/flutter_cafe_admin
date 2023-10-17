import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyAPP());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var db = FirebaseFirestore.instance;
            var data = {'categoryName': '커피', 'isUsed': true};
            await db.collection('cafe-category').add(data);
          },
          child: const Icon(Icons.ac_unit),
        ),
      ),
    );
  }
}
