import 'package:dartz/dartz.dart';

import 'package:ecommerce_app/features/product/domain/usecases/delete_product.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';

import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  //  jsut create the object of the DeleteProduct instace
  //  we can use or call as if it is function
  late DeleteProduct deleteProductTest;
  //  create the mockrepository and use as if it is actual and use the out put
  //  of it as comparator for our use case result
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    deleteProductTest = DeleteProduct(mockProductRepository);
  });

  const testProductId = '1';

  test('Should Delete Product From The Repository', () async {
    //  we try to arrange the mock and call using the same function create for mock repo
    //  and return same type using same input call mock and return result accordingly
    // arrange
    when(mockProductRepository.deleteProduct(testProductId))
        .thenAnswer((_) async => const Right(null));

    // act
    final result =
        await deleteProductTest(const DeleteParams(productId: testProductId));

    //  Expected --> Returned by The mock
    //  Actual  --> Return by actual method

    // assert
    // compare the result and The right of our mock
    expect(result, const Right(null));
    verify(mockProductRepository.deleteProduct(testProductId));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
