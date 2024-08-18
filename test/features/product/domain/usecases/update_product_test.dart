import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';

import 'package:ecommerce_app/features/product/domain/usecases/update_product.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';

import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  late UpdateProduct updateProductTest;
  late MockProductRepository mockProductRepository;
  setUp(() {
    mockProductRepository = MockProductRepository();
    updateProductTest = UpdateProduct(mockProductRepository);
  });
  const testProduct = Product(
    id: '1',
    name: 'Updated Product',
    description: 'Updated Description',
    price: 150.0,
    imageUrl: 'image_url',
  );
  // const testPoductName = 'product';
  test(
    'Should Call This From  ProductRepository',
    () async {
      // arrange
      when(mockProductRepository.updateProduct(testProduct))
          .thenAnswer((_) async => const Right(testProduct));

      // act
      final result =
          await updateProductTest(const UpdateParams(product: testProduct));

      // assert
      expect(result, const Right(testProduct));
      verify(mockProductRepository.updateProduct(testProduct));
      verifyNoMoreInteractions(mockProductRepository);
    },
  );
}
