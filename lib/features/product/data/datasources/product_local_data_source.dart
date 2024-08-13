import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  //  get all cached Product from our data sources return nothing
  Future<void> cachedProducts(ProductModel product);
  //  get specfic cached product using product Id and Return Product Model
  Future<ProductModel?> getCachedProduct(String productId);

  //  Delete Specfic Product and Return Nothing

  Future<void> deleteCachedProducts(String productId);
  // Get All Product That Cached In our Local Storage

  Future<List<ProductModel>> getAllCachedProducts();
}
