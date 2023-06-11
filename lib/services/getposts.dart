// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:sportsapp/models/Post.dart';

// class News {
//   List<Article> news = [];

//   Future<void> getNews() async {
//     var apiKey = "800dce9aa1334456ac941842fa55edf8";

//     Uri url = Uri.parse(
//         "http://newsapi.org/v2/top-headlines?country=in&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=800dce9aa1334456ac941842fa55edf8");
//     var response = await http.get(url);
//     debugPrint("RESPONSE STATUS: ${response.statusCode}");
//     // debugPrint("RESPONSE BODY: ${response.body}");

//     var jsonData = jsonDecode(response.body);
//     // debugPrint("JSON DATA: ${jsonData}");
//     debugPrint("JSON STATUS: ${jsonData['status']}");
//     if (jsonData['status'] == "ok") {
//       jsonData["articles"].forEach((element) {
//         if (element['urlToImage'] != null && element['description'] != null) {
//           Article article = Article(
//             title: element['title'] ?? "",
//             description: element['description'] ?? "",
//             urlToImage: element['urlToImage'] ?? "",
//             content: element['content'] ?? "",
//             publishedAt: DateTime.parse(element['publishedAt']),
//             author: element['author'] ?? "",

//             // publishedAt: DateTime.parse(element['publishedAt']),
//             articleUrl: element['url'] ?? "",
//           );
//           news.add(article);
//         }
//       });
//     }
//   }
// }
