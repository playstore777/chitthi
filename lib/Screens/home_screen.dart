import 'package:chitthi/Screens/create_letter_screen.dart';
import 'package:chitthi/models/letter.dart';
import 'package:chitthi/models/letters_db.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance.currentUser;
  String collection = '';
  CollectionReference<Map<String, dynamic>>? data;
  List letters = [];
  var database = LettersDB();

  @override
  void initState() {
    collection = auth!.email == 'shona@babushona.com' ? 'Her' : 'Him';
    data = FirebaseFirestore.instance.collection(collection);
    database.initDatabase();
    tempFunction();
    super.initState();
  }

  @override
  void dispose() {
    database.closeDatabase();
    super.dispose();
  }

  void tempFunction() async {
    var querySnapshot =
        await data?.where('SentAt', isLessThanOrEqualTo: DateTime.now()).get();
    List<Map<String, dynamic>> firebaseData = [];
    for (var queryDocumentSnapshot in querySnapshot!.docs) {
      firebaseData.add(queryDocumentSnapshot.data());
    }
    debugPrint('tempData: $firebaseData');
    firebaseData.forEach((element) {
      debugPrint('timeStamp time: ${element['SentAt'].seconds.runtimeType}');
      final temp = Letter(
        firstLine: element['FirstLine'],
        mainContent: element['MainContent'],
        sentAt: element['SentAt'].seconds,
      );
      database.insertLetter(temp);
    });
    debugPrint('database data: ${await database.getAllLetters()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collection)
            .where('SentAt', isLessThanOrEqualTo: DateTime.now())
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final letterDocs = chatSnapshot.data?.docs;
          final letters = letterDocs?.map((element) {
            final tempData = element.data();
            debugPrint('tempData from streambuilder: $tempData');
            return {
              'firstLine': tempData['FirstLine'],
              'mainContent': tempData['MainContent'],
              'sentAt': tempData['SentAt']
            };
          }).toList();
          debugPrint(
              'some data: ${(letters?[1]['sentAt']).toDate()}'); // testing purpose only!
          return ListView.builder(
              itemCount: letterDocs?.length,
              itemBuilder: (ctx, index) => Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.secondary,
                        ])),
                    child: Text('${letters?[index]['mainContent']}'),
                  ));
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateLetterScreen(),
            ),
          );
        },
      ),
    );
  }
}
