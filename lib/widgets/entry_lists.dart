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
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('scores').orderBy('created', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount:snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  QueryDocumentSnapshot post = snapshot.data!.docs[index];
                  if(post.data().toString().contains('total_strokes')){
                    return myDismissible(post);
                  }else{
                    return inProgressTile();
                  }
                },
              );
        } else {
          return const Center(child: Text("You have no scores recorded, tap on the button below to start"));
        }
      }
    );
  }

  Widget myDismissible(post){
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(1),
        color: Colors.red,
      ),
      confirmDismiss: (DismissDirection direction)async{
        return await showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Alert"),
              content: const Text("You are about delete this score permanently, are you sure?"),
              actions: [
                TextButton(
                  child:const Text('Cancel'), 
                  onPressed: (){Navigator.pop(context);}
                ),
                TextButton(
                  child:const Text('Delete'), 
                  onPressed: (){
                    Navigator.pop(context);
                    FirebaseFirestore.instance.collection('scores').doc(post.id).delete();
                  }
                ),
              ]
            );
          }
        );
      },
      key: UniqueKey(),
      child:Card(
        margin: const EdgeInsets.all(1),
        color: const Color.fromARGB(255, 236, 223, 195),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('${post['course']}', textAlign: TextAlign.left,),Text('${post['date']}')]
          ),
          subtitle: Text('score: ${post['total_strokes']}, tap to see more details'),
          onTap:() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScoreDetails(post:post)),
            );
          },
        )
      )
    );
  }

  Widget inProgressTile(){
    return ListTile(
      title:Row(
        children: const [
          CircularProgressIndicator(),
          Text('Calculation in progress')
        ],
      )
    );
  }
}
