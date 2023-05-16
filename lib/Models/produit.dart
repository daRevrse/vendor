class Product {
  late final String id;
  late final String name;
  late final String description;
  late final String imageUrl;
  late final double price;
  late final String ownerUid;

  Product({required this.ownerUid, required this.id, required this.name, required this.description, required this.imageUrl, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'ownerUid': ownerUid,
    };
  }

  Product.fromMap(dynamic obj) {
    id = obj['id'].toString();
    name = obj['name'].toString();
    description = obj['description'].toString();
    imageUrl = obj['imageUrl'].toString();
    price = obj['price'];
    ownerUid = obj['ownerUid'].toString();
  }

}
