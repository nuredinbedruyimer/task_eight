import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/insert_product.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late InsertProduct getSingleProductTest;
  late MockProductRepository mockProductRepository;
  setUp(() {
    mockProductRepository = MockProductRepository();
    getSingleProductTest = InsertProduct(mockProductRepository);
  });
  const testproduct = Product(
    id: '1',
    name: 'product',
    price: 100,
    description: 'description',
    imageUrl: 'image Url',
  );
  // const testPoductName = 'product';
  test(
    'should call createProduct from ProductRepository',
    () async {
      // arrange
      when(mockProductRepository.createProduct(testproduct))
          .thenAnswer((_) async => const Right(testproduct));

      // act
      final result = await getSingleProductTest(testproduct);

      // assert
      expect(result, const Right(testproduct));
    },
  );
}
