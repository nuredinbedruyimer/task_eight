import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';

import 'package:ecommerce_app/features/product/domain/usecases/insert_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late InsertProduct createProductUsecase;
  late MockProductRepository mockProductRepository;
  setUp(() {
    mockProductRepository = MockProductRepository();
    createProductUsecase = InsertProduct(mockProductRepository);
  });
  const testproduct = Product(
    id: '1',
    name: 'product',
    price: 100,
    description: 'description',
    imageUrl: 'image_url',
  );
  // const testPoductName = 'product';
  test(
    'Should Call This From  ProductRepository',
    () async {
      // arrange
      when(mockProductRepository.createProduct(testproduct))
          .thenAnswer((_) async => const Right(testproduct));

      // act
      final result = await createProductUsecase(testproduct);

      // assert
      expect(result, const Right(testproduct));
      verify(mockProductRepository.insertProduct(testproduct));
      verifyNoMoreInteractions(mockProductRepository);
    },
  );
}
