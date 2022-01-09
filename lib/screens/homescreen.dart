import 'package:auto_size_text/auto_size_text.dart';
import 'package:bundesumweltwettbewerbapp/choice.dart';
import 'package:bundesumweltwettbewerbapp/networking.dart';
import 'package:bundesumweltwettbewerbapp/post.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
            child: const AutoSizeText(
              "Tipps und Tricks zur Vermeidung von Plastik",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 100,
                fontFamily: "Titillium",
              ),
              maxLines: 1,
              maxFontSize: 100,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<Choice>(
              onSelected: (choice) async {
                await launch(
                  choice.url,
                  enableJavaScript: true,
                );
              },
              itemBuilder: (BuildContext context) {
                return choices.skip(0).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: ListTile(
                      leading: Icon(choice.icon),
                      title: Text(choice.name),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    return FutureBuilder<http.Response>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.statusCode) {
            case 200: {
              final _posts = getPostsFromSnapshot(snapshot);
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
            }
            case 429: return getErrorTextWidget("Der Server hat zu viele Anfragen von diesem Gerät aus bearbeitet. Bitte starten Sie die App in wenigen Minuten neu.", MediaQuery.of(context).size.width * 0.08);
            case 500: return getErrorTextWidget("Es gab einen internen Server Fehler. Bitte versuchen Sie es in ein paar Minuten erneut.", MediaQuery.of(context).size.width * 0.08);
            default: return getErrorTextWidget("Es gab einen Fehler beim Herunterladen der Daten!\nStatus Code: ${snapshot.data!.statusCode}", MediaQuery.of(context).size.width * 0.08);
          }
        } else if (snapshot.hasError) {
          return getErrorTextWidget("Es gab einen Fehler beim Herunterladen der Daten\nDies könnte an einer fehlenden Internetverbindung liegen.", MediaQuery.of(context).size.width * 0.08);
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
        child: AutoSizeText(
          _post.title,
          style: const TextStyle(
              fontSize: 100,
              fontFamily: "Titillium",
              color: Colors.white
          ),
          maxLines: 1,
          maxFontSize: 100,
        )
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: AutoSizeText(
            _post.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 100,
                fontFamily: "Titillium",
                color: Colors.white
            ),
            maxLines: 1,
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
          const Divider(
            thickness: 2.0,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05, top: 20),
                child: Text(
                  _post.text,
                  style: const TextStyle(
                      fontSize: 28,
                      height: 1.1,
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

Widget getErrorTextWidget(String _text, double _margin) {
  return Center(
    child: Container(
      margin: EdgeInsets.all(_margin),
      child: AutoSizeText(
        _text,
        style: const TextStyle(
            fontSize: 100,
            fontFamily: "Titillium",
            color: Colors.red
        ),
        maxLines: 7,
      ),
    ),
  );
}