import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.price,
  });

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      description: product.description,
      price: product.price,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      category: category,
      description: description,
      price: price,
    );
  }
}
