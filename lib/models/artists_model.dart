class Artists {
  final String id;
  final String name;
  final String imageUrl;
  final int popularity;
  final int followers;

  Artists({required this.id, required this.name, required this.imageUrl, required this.popularity, required this.followers});

  factory Artists.fromJson(Map<String, dynamic> json) {
    return Artists(
      id: json['id'],
      name: json['name'],
      imageUrl: json['images'][0]['url'],
      popularity: json['popularity'],
      followers: json['followers']['total'],
    );
  }
}

