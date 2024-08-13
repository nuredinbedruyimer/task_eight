import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> insertProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId);
  Future<ProductModel?> getProduct(String productId);
}
