
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsapp/providers/postprovider.dart';
// import 'package:sportsapp/services/getposts.dart';

// class Body extends StatefulWidget {
//   const Body({Key? key}) : super(key: key);

//   @override
//   _BodyState createState() => _BodyState();
// }

// class _BodyState extends State<Body> {
//   // late bool _loading;
//   var newslist = [];

//   void getNews() async {
//     News news = News();
//     await news.getNews();
//     setState(() {
//       newslist = news.news;
//     });

//   //   // newslist = news.news;
//   }

//   // Future getNews() async {
//   //   var news = await News().news;
//   //   print("newslist: $news");
//   //   setState(() {
//   //     newslist = news;
//   //   });
//   // }

//   @override
//   void initState() {
//     // _loading = true;
//     // TODO: implement initState
//     super.initState();

//     // categories = getCategories();
//     getNews();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final postModel = Provider.of<DataClass>(context);
//     return

//         /// News Article
//         Container(
//       margin: const EdgeInsets.only(top: 16),
//       child: Text(newslist.toString()),
//       // ListView.builder(
//       //     itemCount: newslist.length,
//       //     shrinkWrap: true,
//       //     physics: const ClampingScrollPhysics(),
//       //     itemBuilder: (context, index) {
//       //       return NewsTile(
//       //         imgUrl: newslist[index].urlToImage ?? "",
//       //         title: newslist[index].title ?? "",
//       //         desc: newslist[index].description ?? "",
//       //         content: newslist[index].content ?? "",
//       //         posturl: newslist[index].articleUrl ?? "",
//       //       );
//       //     }),
//     );
//   }
// }
