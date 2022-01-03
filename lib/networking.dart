import 'dart:convert';

import 'package:bundesumweltwettbewerbapp/post.dart';
import 'package:bundesumweltwettbewerbapp/screens/homescreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchData() async {
  return await http.get(Uri.https("raw.githubusercontent.com", "TheLeCrafter/buw-app-data/main/data/app_posts.json"));
}

List<Post> getPostsFromSnapshot(AsyncSnapshot snapshot) {
  final _posts = <Post>[];
  final json = jsonDecode(snapshot.data!.body);
  if (json != null) {
    json.forEach((element) {
      final post = Post.fromJson(element);
      _posts.add(post);
    });
  }
  return _posts;
}

Widget connectivityWidget() {
  return FutureBuilder<ConnectivityResult>(
    future: Connectivity().checkConnectivity(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        ConnectivityResult connectivityResult = snapshot.data!;
        if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
          return HomeScreenState().mainWidget();
        } else {
          return getErrorTextWidget("Sie haben keine aktive Internetverbindung. Bitte öffnen Sie die App erneut, sobald Sie Zugang zum Internet haben.", MediaQuery.of(context).size.width * 0.08);
        }
      } else if (snapshot.hasError) {
        return getErrorTextWidget("Es gab einen Fehler beim Herunterladen der Daten\nBitte melden Sie diesen Fehler: (${snapshot.error})", MediaQuery.of(context).size.width * 0.08);
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}