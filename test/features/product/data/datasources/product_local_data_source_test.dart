import 'dart:convert';

import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  final testProductModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 100.0,
    imageUrl: 'https://example.com/image.jpg',
  );

  final productModelList = [testProductModel];

  group('cacheProduct', () {
    test('should call SharedPreferences to cache the product', () async {
      // Arrange
      final expectedJsonString = jsonEncode(testProductModel.toJson());
      when(mockSharedPreferences.setString(
              'CACHED_PRODUCT_${testProductModel.id}', expectedJsonString))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.cacheProduct(testProductModel);

      // Assert
      verify(mockSharedPreferences.setString(
          'CACHED_PRODUCT_${testProductModel.id}', expectedJsonString));
    });
  });

  group('cacheProducts', () {
    test('should call SharedPreferences to cache the products list', () async {
      // Arrange
      final expectedJsonStringList = productModelList
          .map((product) => jsonEncode(product.toJson()))
          .toList();
      when(mockSharedPreferences.setStringList(
              'CACHED_PRODUCTS', expectedJsonStringList))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.cacheProducts(productModelList);

      // Assert
      verify(mockSharedPreferences.setStringList(
          'CACHED_PRODUCTS', expectedJsonStringList));
    });
  });

  group('deleteCachedProducts', () {
    test('should call SharedPreferences to delete the cached product',
        () async {
      // Arrange
      when(mockSharedPreferences
              .remove('CACHED_PRODUCT_${testProductModel.id}'))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.deleteCachedProducts(testProductModel.id.toString());

      // Assert
      verify(mockSharedPreferences
          .remove('CACHED_PRODUCT_${testProductModel.id}'));
    });
  });

  group('getAllCachedProducts', () {
    test(
        'should return List<ProductModel> from SharedPreferences when there is cached data',
        () async {
      // Arrange
      final expectedJsonStringList = productModelList
          .map((product) => jsonEncode(product.toJson()))
          .toList();
      when(mockSharedPreferences.getStringList('CACHED_PRODUCTS'))
          .thenReturn(expectedJsonStringList);

      // Act
      final result = await dataSource.getAllCachedProducts();

      // Assert
      expect(result, equals(productModelList));
    });

    test('should return an empty list when there is no cached data', () async {
      // Arrange
      when(mockSharedPreferences.getStringList('CACHED_PRODUCTS'))
          .thenReturn([]);

      // Act
      final result = await dataSource.getAllCachedProducts();

      // Assert
      expect(result, equals([]));
    });
  });

  group('getCachedProduct', () {
    test(
        'should return ProductModel from SharedPreferences when there is cached data',
        () async {
      // Arrange
      final expectedJsonString = jsonEncode(testProductModel.toJson());
      when(mockSharedPreferences
              .getString('CACHED_PRODUCT_${testProductModel.id}'))
          .thenReturn(expectedJsonString);

      // Act
      final result =
          await dataSource.getCachedProduct(testProductModel.id.toString());

      // Assert
      expect(result, equals(testProductModel));
    });

    test('should return null when there is no cached data', () async {
      // Arrange
      when(mockSharedPreferences
              .getString('CACHED_PRODUCT_${testProductModel.id}'))
          .thenReturn(null);

      // Act
      final result =
          await dataSource.getCachedProduct(testProductModel.id.toString());

      // Assert
      expect(result, equals(null));
    });
  });
}
