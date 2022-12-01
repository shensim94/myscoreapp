import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';


class MySearchDelegate extends SearchDelegate {
  List<String> searchTerms;
  MySearchDelegate({Key? key, required this.searchTerms});
  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
    IconButton(
      onPressed: () {
        query = '';
      },
      icon: Icon(Icons.clear),
    ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
    onPressed: () {
      close(context, null);
    },
    icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: (){
            query = result;
            close(context, query);
          },
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
    if (fruit.toLowerCase().contains(query.toLowerCase())) {
      matchQuery.add(fruit);
    }
    }
    return ListView.builder(
    itemCount: matchQuery.length,
    itemBuilder: (context, index) {
      var result = matchQuery[index];
      return ListTile(
        title: Text(result),
        onTap: (){
          query = result;
          close(context, query);
        },
      );
    },
    );
  }
}
