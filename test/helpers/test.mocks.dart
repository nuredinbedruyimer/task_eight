import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
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
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
