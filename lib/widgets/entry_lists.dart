import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'score_details.dart';

class EntryLists extends StatefulWidget {
  const EntryLists({Key? key}) : super(key: key);
  @override
  _EntryListsState createState() => _EntryListsState();
}

class _EntryListsState extends State<EntryLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Score Card')),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('scores').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs != null &&
                snapshot.data!.docs.length > 0) {
                  return ListView.builder(
                    itemCount:snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      var post = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap:() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ScoreDetails()),
                          );
                        },
                        child: ListTile(
                          title: Text('${post['course']}, date placeholder, score placeholder'),
                          subtitle: Text('tap to see more details'),
                        )
                      );
                    },
                  );

            } else {
              return Center(child: const Text("You have no scores recorded, tap on the button below to start"));
            }
          }),
          
    );
  }
}
