import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  //  used to insert data to our remotte data source return nothing
  Future<ProductModel> createProduct(ProductModel product);
  //  used to update the product with product specfic product return othing
  Future<ProductModel> updateProductRemote(ProductModel product);
  //  delete specfic product using product id return nothing
  Future<void> deleteProductRemote(String productId);
  // fetch specfic data by using product id and return it
  Future<ProductModel?> fetchProduct(String productId);
  //  fetch all data and return as alist
  Future<List<ProductModel>> fetchAllProducts();
}
