import '../../domain/entities/product.dart';

class ProductModel extends Product {
  // this part ensure the neeed of this 5 field to be model
  // create instance(object Of product in this manner)
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
  });

  // Convert a ProductModel into a Map (for JSON)
  // it convert the given dart object(product Model) to its corresbondin json
  //  and it return the returned map of key as string and value ans any value dynamic
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Create a ProductModel from a Map (from JSON)
  //  it get product model from the given json(map<string, dynamic>) ans
  //  return the converted product model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      // id is come from json with key as id and make it string
      id: json['id'] as String,
      // name come from json with key name and make it string
      name: json['name'] as String,
      // description come from json with key description  and make it string
      description: json['description'] as String,
      //  to make price double we have to use toDouble because it data type is Double in the model part
      price: (json['price'] as num).toDouble(), // ensure price is a double
      imageUrl: json['imageUrl'] as String,
    );
  }
}
