class SingleRssFeed {
  final int id;
  final int rssId;
  final String title;
  final String author;
  final String content;
  final String link;
  final int createdAt;

  SingleRssFeed({
    this.id,
    this.rssId,
    this.title,
    this.author,
    this.content,
    this.link,
    this.createdAt
  });

  factory SingleRssFeed.fromJson(Map<String, dynamic> json) => SingleRssFeed(
    id: json['id'],
    rssId: json['rss_id'],
    title: json['title'],
    author: json['author'],
    content: json['content'],
    link: json['link'],
    createdAt: json['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'rss_id': this.rssId,
    'title': this.title,
    'author': this.author,
    'content': this.content,
    'link': this.link,
    'createdAt': this.createdAt
  };
}
