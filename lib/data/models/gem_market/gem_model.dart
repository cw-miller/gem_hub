import 'package:job_market/core/enums/gem_status.dart';

class Gem {
  // 1. Changed type to String to match Django UUIDField
  // 2. Changed key name to 'gem_id' to match your Django model
  final String? gemId; 
  final String owner;
  final String name;
  final double? carat;
  final double? price;
  final String? description;
  final String? imageUrl;
  final String? location;
  final String? sellerPhone;
  final GemStatus status;

  Gem({
    this.gemId,
    required this.owner,
    required this.name,
    this.carat,
    this.price,
    this.description,
    this.imageUrl,
    this.location,
    this.sellerPhone,
    this.status = GemStatus.PENDING,
  });

  factory Gem.fromMap(Map<String, dynamic> map) {
    return Gem(
      // Match the 'gem_id' from your Django table
      gemId: map['gem_id'], 
      // Handle potential nested Profile object or simple ID string
      owner: map['owner'] is Map 
          ? map['owner']['profile'].toString() 
          : map['owner'].toString(),
      name: map['name'] ?? '',
      carat: (map['carat'] as num?)?.toDouble(),
      price: (map['price'] as num?)?.toDouble(),
      description: map['description'],
      imageUrl: map['image_url'],
      location: map['location'],
      sellerPhone: map['seller_phone'],
      status: GemStatus.fromString(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // Don't include gemId in toMap if you want Django/Postgres to generate it
      'owner': owner,
      'name': name,
      'carat': carat,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'location': location,
      'seller_phone': sellerPhone,
      'status': status.name.toLowerCase(), 
    };
  }
}