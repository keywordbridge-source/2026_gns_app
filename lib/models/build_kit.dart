class BuildKit {
  final String id;
  final String theme;
  final String brand;
  final String productName;
  final int partsCount;
  final String image1;
  final String image2;
  final String image3;
  final String image4;

  BuildKit({
    required this.id,
    required this.theme,
    required this.brand,
    required this.productName,
    required this.partsCount,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
  });

  factory BuildKit.fromMap(Map<String, dynamic> map) {
    return BuildKit(
      id: map['id'] ?? '',
      theme: map['theme'] ?? '',
      brand: map['brand'] ?? '',
      productName: map['productName'] ?? '',
      partsCount: map['partsCount'] ?? 0,
      image1: map['image1'] ?? '',
      image2: map['image2'] ?? '',
      image3: map['image3'] ?? '',
      image4: map['image4'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'theme': theme,
      'brand': brand,
      'productName': productName,
      'partsCount': partsCount,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
    };
  }
}
