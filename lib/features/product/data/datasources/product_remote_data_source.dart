import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  //  used to insert data to our remotte data source return nothing
  Future<void> createProduct(ProductModel product);
  //  used to update the product with product specfic product return othing
  Future<void> updateProduct(ProductModel product);
  //  delete specfic product using product id return nothing
  Future<void> deleteProduct(String productId);
  // fetch specfic data by using product id and return it
  Future<ProductModel?> fetchProduct(String productId);
  //  fetch all data and return as alist
  Future<List<ProductModel>> fetchAllProducts();
}
