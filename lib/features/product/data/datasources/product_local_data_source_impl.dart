import 'dart:convert';

import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl({required this.sharedPreferences});
  final cachedKey = 'CACHED_PRODUCTS';

  final SharedPreferences sharedPreferences;
  @override
  Future<void> cacheProduct(ProductModel product) async {
    final jsonString = jsonEncode(product.toJson());
    await sharedPreferences.setString(
        'CACHED_PRODUCT_${product.id}', jsonString);
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonStringList =
        products.map((product) => jsonEncode(product.toJson())).toList();
    await sharedPreferences.setStringList('CACHED_PRODUCTS', jsonStringList);
  }

  @override
  Future<void> deleteCachedProducts(String productId) async {
    // Delete The Poduct with Product Id Using Product Id
    await sharedPreferences.remove('CACHED_PRODUCT_$productId');
  }

  @override
  Future<List<ProductModel>> getAllCachedProducts() async {
    //  get all List of STring from the preferene and return the values
    final jsonStringList = sharedPreferences.getStringList(cachedKey);
    //  check non nullablity and iterate over them and convert them
    //  to valid prodct object and  then we only aceept list of ptoduct obect
    if (jsonStringList != null && jsonStringList.isNotEmpty) {
      return jsonStringList
          .map((jsonString) => ProductModel.fromJson(jsonDecode(jsonString)))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<ProductModel?> getCachedProduct(String productId) async {
    //  we try to find data from shared preference using the unique id of product
    //  we give for all of the data
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_$productId');
    // check if it is valid value or not
    if (jsonString != null) {
      return ProductModel.fromJson(jsonDecode(jsonString));
    } else {
      return null;
    }
  }
}
