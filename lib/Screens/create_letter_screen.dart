import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateLetterScreen extends StatefulWidget {
  const CreateLetterScreen({super.key});

  @override
  State<CreateLetterScreen> createState() => _CreateLetterScreenState();
}

class _CreateLetterScreenState extends State<CreateLetterScreen> {
  final auth = FirebaseAuth.instance.currentUser;
  CollectionReference<Map<String, dynamic>>? firebaseFirestore;
  String collection = '';
  final TextEditingController _firstLineController = TextEditingController();
  final TextEditingController _mainContentController = TextEditingController();

  @override
  void initState() {
    collection = auth!.email == 'shona@babushona.com' ? 'Him' : 'Her';
    firebaseFirestore = FirebaseFirestore.instance.collection(collection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () {
              debugPrint('clicked: ${_mainContentController.text}');
              firebaseFirestore?.add({
                'FirstLine': _firstLineController.text,
                'MainContent': _mainContentController.text,
                'SentAt': DateTime.now().add(const Duration(days: 1)),
              });

              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save),
          )
        ]),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: _firstLineController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Dear love'),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: _mainContentController,
              cursorColor: Colors.white,
              maxLength: null,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: null,
                labelText: 'Your message here...',
                alignLabelWithHint: true,
              ),
            ),
          ]),
        ));
  }
}
