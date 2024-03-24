class WebTypes {
  final String id;
  final String title;
  final String subtitle;
  final String image;

  WebTypes(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.image});

  factory WebTypes.fromJson(Map<String, dynamic> json) {
    return WebTypes(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
    );
  }
}
