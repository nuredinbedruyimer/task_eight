import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_app/core/constants/constants.dart';
import 'package:ecommerce_app/core/errors/exception.dart';
import 'package:ecommerce_app/features/product/data/datasources/poduct_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.json_reader.dart';
import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late PoductRemoteDataSourceImpl productRemoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    productRemoteDataSourceImpl =
        PoductRemoteDataSourceImpl(client: mockHttpClient);
  });

  const productId = '6672776eb905525c145fe0bb';
  const singleTestJson = 'dummy_product_json.json';

  const multipleTestJson = 'dummy_all_product_json_response.json';
  const testProductModel = ProductModel(
      id: '6672776eb905525c145fe0bb',
      name: 'Anime website',
      description: 'Explore anime characters.',
      imageUrl:
          'https://res.cloudinary.com/g5-mobile-track/image/upload/v1718777711/images/clmxnecvavxfvrz9by4w.jpg',
      price: 123);

  group('get current product', () {
    test('should return product model when the response code is 200', () async {
      //arrange
      when(mockHttpClient.get(Uri.parse(Urls.getID(productId)))).thenAnswer(
          (_) async => http.Response(readJson(singleTestJson), 200));

      //act
      final result = await productRemoteDataSourceImpl.fetchProduct(productId);

      //assert
      expect(result, isA<ProductModel>());
    });

    test('should throw server exception if status code is other than 200',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse(Urls.getID(productId)))).thenAnswer(
          (_) async => http.Response(readJson(singleTestJson), 400));

      //act and assert
      // verify(mockHttpClient.get(any));
      expect(() => productRemoteDataSourceImpl.fetchProduct(productId),
          throwsA(isA<ServerException>()));
    });

    test('should throw a socket exception if it happens', () {
      //arrange
      when(mockHttpClient.get(Uri.parse(Urls.getID(productId)))).thenThrow(
          const SocketException(
              'No Internet connection or server unreachable'));

      //act
      final call = productRemoteDataSourceImpl.fetchProduct(productId);

      //assert
      expect(() => call, throwsA(isA<SocketException>()));
    });
  });

  group('getAllProducts', () {
    test('should return a list of product models if status code is 200',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse(Urls.baseUrl))).thenAnswer(
          (_) async => http.Response(readJson(multipleTestJson), 200));

      //act
      final result = await productRemoteDataSourceImpl.fetchAllProducts();

      //assert
      expect(result, isA<List<ProductModel>>());
    });

    test('should throw a server exception if status code is different from 200',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse(Urls.baseUrl))).thenAnswer(
          (_) async => http.Response(readJson(multipleTestJson), 400));

      //act and assert
      expect(() => productRemoteDataSourceImpl.fetchAllProducts(),
          throwsA(isA<ServerException>()));
    });

    test('should throw a socket exception if it happens', () {
      //arrange
      when(mockHttpClient.get(Uri.parse(Urls.baseUrl))).thenThrow(
          const SocketException(
              'No Internet connection or server unreachable'));

      //act
      final call = productRemoteDataSourceImpl.fetchAllProducts();

      //assert
      expect(() => call, throwsA(isA<SocketException>()));
    });
  });

  group('deleteProduct', () {
    test('should delete successfully', () async {
      //arrange
      final url = Uri.parse(Urls.getID(productId));
      when(mockHttpClient.delete(url))
          .thenAnswer((_) async => http.Response('', 200));

      //act
      await productRemoteDataSourceImpl.deleteProductRemote(productId);

      //assert
      verify(mockHttpClient.delete(url));
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      // arrange
      when(mockHttpClient.delete(any))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = productRemoteDataSourceImpl.deleteProductRemote(productId);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
    test('should throw a socket exception if it happens', () {
      //arrange
      when(mockHttpClient.delete(any)).thenThrow(const SocketException(
          'No Internet connection or server unreachable'));

      //act
      final call = productRemoteDataSourceImpl.deleteProductRemote(productId);

      //assert
      expect(() => call, throwsA(isA<SocketException>()));
    });
  });

  group('updateProductRemote', () {
    test('should return an updated product model if status code is 200',
        () async {
      //arrange
      final jsonBody = jsonEncode({
        'name': testProductModel.name,
        'description': testProductModel.description,
        'price': testProductModel.price,
      });
      when(mockHttpClient
          .put(Uri.parse(Urls.getID(productId)), body: jsonBody, headers: {
        'Content-Type': 'application/json'
      })).thenAnswer((_) async => http.Response(readJson(singleTestJson), 200));

      //act
      final result = await productRemoteDataSourceImpl
          .updateProductRemote(testProductModel);

      //assert
      expect(result, testProductModel);
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      // arrange
      final jsonBody = jsonEncode({
        'name': testProductModel.name,
        'description': testProductModel.description,
        'price': testProductModel.price,
      });
      when(mockHttpClient.put(Uri.parse(Urls.getID(productId)),
              body: jsonBody, headers: {'Content-Type': 'application/json'}))
          .thenAnswer((_) async => http.Response('Something went wrong', 500));

      // act
      final call = await productRemoteDataSourceImpl.updateProductRemote;

      // assert
      expect(() => call(testProductModel), throwsA(isA<ServerException>()));
    });

    test('should throw a socket exception if it happens', () {
      //arrange
      final jsonBody = jsonEncode({
        'name': testProductModel.name,
        'description': testProductModel.description,
        'price': testProductModel.price,
      });
      when(mockHttpClient.put(Uri.parse(Urls.getID(productId)),
              body: jsonBody, headers: {'Content-Type': 'application/json'}))
          .thenThrow(const SocketException(
              'No Internet connection or server unreachable'));

      //act
      final call = productRemoteDataSourceImpl.updateProductRemote;

      //assert
      expect(() => call(testProductModel), throwsA(isA<SocketException>()));
    });
  });
}
