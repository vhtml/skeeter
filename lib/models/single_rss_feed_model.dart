class SingleRssFeed {
  final int id;
  final int rssId;
  final String title;
  final String author;
  final String description;
  final String content;
  final String pubDate;
  final String link;
  final String images;
  final int createdAt;

  SingleRssFeed({
    this.id,
    this.rssId,
    this.title,
    this.author,
    this.description,
    this.content,
    this.pubDate,
    this.link,
    this.images,
    this.createdAt
  });

  factory SingleRssFeed.fromJson(Map<String, dynamic> json) => SingleRssFeed(
    id: json['id'],
    rssId: json['rss_id'],
    title: json['title'],
    author: json['author'],
    description: json['description'],
    content: json['content'],
    pubDate: json['pub_date'],
    link: json['link'],
    images: json['images'],
    createdAt: json['created_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'rss_id': this.rssId,
    'title': this.title,
    'author': this.author,
    'description': this.description,
    'content': this.content,
    'pub_date': this.pubDate,
    'link': this.link,
    'images': this.images,
    'created_at': this.createdAt
  };
}
