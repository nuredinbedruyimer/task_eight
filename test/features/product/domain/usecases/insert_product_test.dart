import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';

import 'package:ecommerce_app/features/product/domain/usecases/insert_product.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';

import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  late InsertProduct insertProductUsecase;
  late MockProductRepository mockProductRepositories;

  setUp(() {
    mockProductRepositories = MockProductRepository();
    insertProductUsecase = InsertProduct(mockProductRepositories);
  });
  const testProductDetails = Product(
      id: '1',
      name: 'Nike',
      description: 'Nike is the Best',
      price: 344,
      imageUrl: 'imageUrl');
  test('should insert product to the repository', () async {
    //arrange
    when(mockProductRepositories.insertProduct(testProductDetails))
        .thenAnswer((_) async => const Right(testProductDetails));
    //act
    final result = await insertProductUsecase(testProductDetails);
    //assert
    expect(result, const Right(testProductDetails));
  });
}
