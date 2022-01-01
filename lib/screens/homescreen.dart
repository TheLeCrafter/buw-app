import 'dart:convert';

import 'package:bundesumweltwettbewerbapp/networking.dart';
import 'package:bundesumweltwettbewerbapp/post.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: const Text(
            "Tipps und Tricks zur Vermeidung von Plastik",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              fontFamily: "Titillium",
            ),
        ),
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    final _posts = <Post>[];
    return FutureBuilder<http.Response>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.statusCode == 200) {
            final json = jsonDecode(snapshot.data!.body);
            if (json != null) {
              json.forEach((element) {
                final post = Post.fromJson(element);
                _posts.add(post);
              });
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _posts.length,
              itemBuilder: (context, i) {
                if (i.isOdd) {
                  return const Divider();
                }
                return _buildRow(_posts[i ~/ 2]);
              },
            );
          } else if(snapshot.data!.statusCode == 429) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  "Der Server hat zu viele Anfragen von diesem Gerät aus bearbeitet. Bitte starten Sie die App in wenigen Minuten neu.",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Titillium",
                      color: Colors.white
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  "Es gab einen Fehler beim Herunterladen der Daten!\nStatus Code: ${snapshot.data!.statusCode}",
                  style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Titillium",
                      color: Colors.white
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text("Es gab einen Fehler beim Herunterladen der Daten\nBitte melden Sie diesen Fehler: (${snapshot.error})");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildRow(Post _post) {
    return ListTile(
      title: Center(
        child: Text(
          _post.title,
          style: const TextStyle(
              fontSize: 20,
              fontFamily: "Titillium",
              color: Colors.white
          ),
        ),
      ),
      onTap: () {
        _pushDetail(_post);
      },
    );
  }

  void _pushDetail(Post _post) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) {
          return detailedWidget(_post);
        })
    );
  }

  Widget detailedWidget(Post _post) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: Text(
          _post.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: "Titillium",
              color: Colors.white
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getDetailedImage(_post)
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Text(
                  _post.text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: "Titillium",
                      color: Colors.white
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getDetailedImage(Post _post) {
    return Image.network(
      _post.imageUrl,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.28,
      fit: BoxFit.cover,
    );
  }
}