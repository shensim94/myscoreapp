import 'package:flutter/material.dart';

class ScoreDetails extends StatelessWidget{
  const ScoreDetails({Key?key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Score details")
      ),
      body: const Center(child: Text("score details goes here, not yet implemented"),)

    );
  }
}