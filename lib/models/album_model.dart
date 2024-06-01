class Album {
  String id;
  String name;
  String imageUrl;

  Album({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url'] as String
          : '',
    );
  }
}
