class RssItemModel {
  final int id;
  final String iconUrl;
  final String title;
  final String link;
  final String lastBuildDate;
  final int createdAt;

  RssItemModel({
    this.id,
    this.iconUrl,
    this.title,
    this.link,
    this.lastBuildDate,
    this.createdAt
  });

  factory RssItemModel.fromJson(Map<String, dynamic> json) => RssItemModel(
    id: json['id'],
    iconUrl: json['icon_url'],
    title: json['title'],
    link: json['link'],
    lastBuildDate: json['last_build_date'],
    createdAt: json['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'icon_url': this.iconUrl,
    'title': this.title,
    'link': this.link,
    'last_build_date': this.lastBuildDate,
    'createdAt': this.createdAt
  };
}