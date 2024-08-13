import 'package:dartz/dartz.dart';

import 'package:ecommerce_app/features/product/domain/usecases/delete_product.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';

import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  late DeleteProduct deleteProduct;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    deleteProduct = DeleteProduct(mockProductRepository);
  });

  const testProductId = '1';

  test('should delete product from the repository', () async {
    // arrange
    when(mockProductRepository.deleteProduct(testProductId))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await deleteProduct(testProductId);

    // assert
    expect(result, const Right(null));
    verify(mockProductRepository.deleteProduct(testProductId));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
