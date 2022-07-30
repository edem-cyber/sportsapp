class News {
  String? status;
  int? totalResults;
  List<Article>? articles;

  News({this.status, this.totalResults, this.articles});

  News.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = <Article>[];
      json['articles'].forEach((v) {
        articles!.add(Article.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    if (articles != null) {
      data['articles'] = articles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Article {
  Source? source;
  String? title;
  String? author;
  String? description;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;
  String? articleUrl;

  Article(
      {this.source,
      this.title,
      this.description,
      this.author,
      this.content,
      this.publishedAt,
      this.urlToImage,
      this.articleUrl});

  Article.fromJson(Map<String, dynamic> json) {
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    title = json['title'];
    author = json['author'];
    description = json['description'];
    urlToImage = json['urlToImage'];
    publishedAt = DateTime.parse(json['publishedAt']);
    content = json['content'];
    articleUrl = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (source != null) {
      data['source'] = source!.toJson();
    }
    data['author'] = author;
    data['title'] = title;
    data['description'] = description;
    data['url'] = articleUrl;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    return data;
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
