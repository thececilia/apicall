import 'dart:convert';
import 'dart:io';

import 'package:apicallproj/model/news_model.dart';
import 'package:apicallproj/util/failure.dart';
import 'package:http/http.dart' as http;

class ApiCallClass {
  Future<List<Article>> getNews() async {
    try {
      final news = await http.get(
          Uri.parse(
              "https://newsapi.org/v2/everything?q=apple&from=2021-05-16&to=2021-05-16&sortBy=popularity&apiKey=0e98fba49a36420e97c5c748db98e14b"),
      );
      if (news.statusCode == 200) {
        final Iterable rawJson = jsonDecode(news.body)["articles"];
        return rawJson.map((article) => Article.fromJson(article)).toList();
      } else {
        throw Failure(message: news.body.toString());
      }
    } on SocketException {
      throw Failure(message: "You are not connected to the Internet");
    } catch (error) {
      throw Failure(message: error.toString());
    }
  }
}