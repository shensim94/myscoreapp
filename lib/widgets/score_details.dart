import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ScoreDetails extends StatefulWidget{
  QueryDocumentSnapshot post;

  ScoreDetails({Key?key, required this.post}) : super(key: key);

  @override
  State<ScoreDetails> createState() => _ScoreDetailsState();
}

class _ScoreDetailsState extends State<ScoreDetails> {
  
  late bool unknown;
  late int greens;
  late QueryDocumentSnapshot post;
  late String date;
  late String course;
  late String distance;
  late String par;
  late String score;
  late String putts;
  late String gir;
  late String fir;
  late String dist;
  late int fairways;

  @override
  void initState(){
    post = widget.post;
    unknown = post['course'] == "unknown";
    greens = post['scores'].length;
    fairways = fairwayCount();
    date = "${post['date']}";
    course = unknown?"N/A":"${post['course']}";
    distance = unknown?"N/A":"${post['total_dist']}";
    par = unknown?"N/A":"${post['total_par']}";
    score = post['complete']?"${post['total_strokes']}":"${post['total_strokes']}(incomplete)";
    putts = countPutts();
    gir = "${post['green_successes']}/$greens";
    fir = unknown?"${post['fairway_hits']}/?":"${post['fairway_hits']}/$fairways";
    dist = post['driving_dist']==0?"N/A":"${post['driving_dist']}";
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child:Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Score Details"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.notes)),
              Tab(icon: Icon(Icons.table_chart))
            ]
          ),
        ),
        body: TabBarView(
          children: [
            scoreSummary(),
            scoreDetails()
          ]
        )
      )
    );
  }

  ////////////////
  /// WIDGETS ////
  ////////////////

  Widget scoreSummary(){
    return Center(
      child:SizedBox(
        width: 340,
        child:Card(
          color: const Color.fromARGB(255, 236, 223, 195),
          child: Table(
            columnWidths: const {
              0:FlexColumnWidth(2),
              1:FlexColumnWidth(4)
            },
            border:const TableBorder(
              verticalInside: BorderSide(color: Color.fromARGB(255, 182, 170, 120)),
              top:BorderSide.none,
            ),
            children: [
              myTableRow('Date', date),
              myTableRow('Course', course),
              myTableRow('Distance', distance),
              myTableRow('Par', par),
              myTableRow('Your Score', score),
              myTableRow('Putts', putts),
              myTableRow('GIR', gir),
              myTableRow('FIR', fir),
              myTableRow('Driving Dist.', dist),
            ],
          ),
        )
      )
    );
  }

  Widget scoreDetails(){
    return Center(
      child:SizedBox(
        width: 340,
        child:Card(
          color: const Color.fromARGB(255, 236, 223, 195),
          child:Column(
            children: [
              Text(course),
              const Padding(
                padding: EdgeInsets.all(4),
                child:Text('Front Nine')
              ),
              getTable(0, 8),
              const Padding(
                padding: EdgeInsets.all(4),
                child:Text('Back Nine')
              ),
              getTable(9, 17)
            ]
          )
        )
      )
    );
  }

  TableRow myTableRow(String left, String right){
    return TableRow(
      children:[
        Padding(padding: const EdgeInsets.all(3), child: Text(left, style: const TextStyle(fontFamily:'Edu_SA', fontSize:20))),
        Padding(padding: const EdgeInsets.all(3), child: Text(right, textAlign: TextAlign.end, style: const TextStyle(fontFamily:'Edu_SA', fontSize:20)))
      ]
    );
  }

  TableRow scoreRow(score){
    return TableRow(
      children: [
        Center(child: score['holeNum']!=null?Text("${score['holeNum']}"):const Icon(Icons.clear)),
        Center(child: score['hole_dist']!=null?Text("${score['hole_dist']}"):const Icon(Icons.clear)),
        Center(child: score['hole_par']!=null?Text("${score['hole_par']}"):const Icon(Icons.clear)),
        Center(child: score['strokes']!=null?Text("${score['strokes']}"):const SizedBox()),
        Center(child: score['drive_dist']!=null?Text("${score['drive_dist']}"):const SizedBox()),
        Center(child: score['fairway']? const Icon(Icons.check):const SizedBox()),
        Center(child: score['green']? const Icon(Icons.check):const SizedBox()),
        Center(child: score['putts']!=null? Text("${score['putts']}"):const SizedBox()),
      ]);
  }

  TableRow tableHeader(){
    return const TableRow(
      children: [
        SizedBox(),
        Center(child:Text('Dist')),
        Center(child:Text('Par')),
        Center(child:Text('Score')),
        Center(child:Text('Drive')),
        Center(child:Text('FIR')),
        Center(child:Text('GIR')),
        Center(child:Text('Putts')),
      ]
    );
  }

  List<TableRow> getScoreRows(int start, int end){
    List<TableRow> rows = [];
    rows.add(tableHeader());
    for (int i = start; i <= end; i++){
      rows.add(scoreRow(post['scores'][i]));
    }
    return rows;
  }

  Table getTable(int start, int end){
    return Table(
      columnWidths: const {
        0:FlexColumnWidth(1),
        1:FlexColumnWidth(2),
        2:FlexColumnWidth(2),
        3:FlexColumnWidth(2),
        4:FlexColumnWidth(2),
        5:FlexColumnWidth(1.5),
        6:FlexColumnWidth(1.5),
        7:FlexColumnWidth(2),
      },
      border: TableBorder.all(),
      children: getScoreRows(start, end),
    );
  }

  ////////////////
  /// METHODS ////
  ////////////////

  int fairwayCount(){
    int count = 18;
    for (var e in post['scores']){
      if (e['hole_par'] == 3){
        count--;
      }
    }
    return count;
  }

  String countPutts(){
    if(post['total_putts']==0){
      putts = "N/A";
      return putts;
    }
    for(var e in post['scores']){
      if (e['putts']==null){
        putts = "${post['total_putts']}(incomplete)";
        return putts;
      }
    }
    putts = "${post['total_putts']}";
    return putts;
  }
}
