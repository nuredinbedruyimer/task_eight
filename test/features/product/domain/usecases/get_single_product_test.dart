import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_single_product.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';

import '../../helpers/test.mocks.mocks.dart';

void main() {
  late GetSingleProduct getSingleProduct;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getSingleProduct = GetSingleProduct(mockProductRepository);
  });

  const testProductId = '1';
  const testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 99.99,
    imageUrl: 'Test Category',
  );

  test('should get product from the repository', () async {
    // arrange
    when(mockProductRepository.getSingleProduct(testProductId))
        .thenAnswer((_) async => const Right(testProduct));

    // act
    final result = await getSingleProduct(testProductId);

    // assert
    expect(result, const Right(testProduct));
    verify(mockProductRepository.getSingleProduct(testProductId));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
