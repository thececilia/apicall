import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:apicallproj/model/news_model.dart';
import 'package:apicallproj/api/api_call.dart';

//Run|Debug
void main() {
  runApp(ApiApp());
}

class ApiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final news = ApiCallClass().getNews();

  @override
  void initState() {
    print("Start building widget");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apple News'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Article>>(
        future: news,
        builder: (context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                  backgroundImage:
                  NetworkImage(snapshot.data[index].urlToImage == null ? "": snapshot.data[index].urlToImage)
              ),
              title: Text(snapshot.data[index].title == null ? "" : snapshot.data[index].title),
              subtitle:Text(snapshot.data[index].author == null ? "" : snapshot.data[index].author),
              trailing: IconButton(
                icon: Icon(Icons.launch),
                onPressed: () async {
                  await canLaunch(snapshot.data[index].url)
                      ? launch(snapshot.data[index].url)
                      : throw "Couldn't launch url ${snapshot.data[index].url}";
          }
          )
              )
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      );

  }
}