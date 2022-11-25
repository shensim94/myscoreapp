import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'score_details.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EntryLists extends StatefulWidget {
  const EntryLists({Key? key}) : super(key: key);
  @override
  _EntryListsState createState() => _EntryListsState();
}

class _EntryListsState extends State<EntryLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Score Card')),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('scores').orderBy('created', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs != null &&
                snapshot.data!.docs.length > 0) {
                  return ListView.builder(
                    itemCount:snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      QueryDocumentSnapshot post = snapshot.data!.docs[index];
                      if(post.data().toString().contains('total_strokes')){
                        return GestureDetector(
                          onTap:() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ScoreDetails()),
                            );
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                            ),
                            onDismissed: (DismissDirection direction){
                              FirebaseFirestore.instance.collection('scores').doc(post.id).delete();
                            },
                            key: ValueKey<int>(index),
                            child: ListTile(
                              title: Text('${post['course']}, ${post['date']}, ${post.id}'),
                              subtitle: Text('score: ${post['total_strokes']}, tap to see more details'),
                            )
                          )
                          
                        );
                      }else{
                        return ListTile(
                          title:Row(
                            children: const [
                              CircularProgressIndicator(),
                              Text('Calculation in progress')
                            ],
                          )
                        );
                      }
                    },
                  );

            } else {
              return const Center(child: Text("You have no scores recorded, tap on the button below to start"));
            }
          }),
          
    );
  }
}
