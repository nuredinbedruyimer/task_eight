// lib/features/product/domain/entities/product.dart this is the folder path to get in to the given file

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double price;

  @override
  List<Object?> get props => [id, name, description, price, imageUrl];
}
