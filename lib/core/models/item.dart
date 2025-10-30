class Item {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageURL;
  final double rating;
  final int ratingCount;

  Item({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageURL,
    required this.rating,
    required this.ratingCount,
  });    

  factory Item.fromJson(Map<String, dynamic> json) {
    final ratingObj = json['rating'] as Map<String, dynamic>?;

    return Item(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      imageURL: json['image'],
      rating: ((ratingObj?['rate'] ?? 0) as num).toDouble(),
      ratingCount: ((ratingObj?['count'] ?? 0) as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': imageURL,
        'rating': {
          'rate': rating,
          'count': ratingCount,
        },
      };
}