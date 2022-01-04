import 'dart:convert';

import 'package:bundesumweltwettbewerbapp/post.dart';
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