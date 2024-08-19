import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_single_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  ProductRepository,
  ProductRemoteDataSource,
  ProductLocalDataSource,
  NetworkInfo,
  InternetConnectionChecker,
  SharedPreferences,
  GetProduct,
  GetSingleProduct,
  DeleteProduct,
  UpdateProduct,
  InsertProduct,
  UseCase,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
