import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/constants/constants.dart';
import 'package:ecommerce_app/core/errors/failure.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_single_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  late MockGetProduct mockGetProduct;
  late MockGetSingleProduct mockGetSingleProduct;
  late MockInsertProduct mockInsertProduct;
  late MockUpdateProduct mockUpdateProduct;
  late MockDeleteProduct mockDeleteProduct;
  late ProductBloc productBloc;

  setUp(() {
    mockGetProduct = MockGetProduct();
    mockGetSingleProduct = MockGetSingleProduct();
    mockInsertProduct = MockInsertProduct();
    mockUpdateProduct = MockUpdateProduct();
    mockDeleteProduct = MockDeleteProduct();
    productBloc = ProductBloc(mockGetProduct, mockGetSingleProduct,
        mockUpdateProduct, mockDeleteProduct, mockInsertProduct);
  });

  const testProductEntitiy = Product(
      id: '1',
      name: 'Product 1',
      description: 'Product 1 description',
      imageUrl: 'product1.jpg',
      price: 100);

  const testId = '1';

  test('Intial State Should Be Tested And Get The Correct Intial State', () {
    expect(productBloc.state, ProductInitialState());
  });

  group('GetSingleProduct Event', () {
    // Testing GetSIngleProductEvent
    /**
     * Test GetSIngleProductDvent when we give GetSingleProductEvent
     * First We have Loading... state
     * The We have Two case success and Failure handle byr
     * returning ProductErrorState or ProductCurrentState
     * 
     * 
     */
    blocTest<ProductBloc, ProductState>(
        'Emits [ProductLoading, LoadSingleProductState] when GetSingleProductEvent is consumed.',
        build: () {
          return productBloc;
        },
        setUp: () {
          when(mockGetSingleProduct(const GetParams(productId: testId)))
              .thenAnswer((_) async => const Right(testProductEntitiy));
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent(productId: testId)),
        expect: () => [
              ProductLoading(),
              const LoadSingleProductState(product: testProductEntitiy)
            ]);
    blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, ErrorState] when GetSingleProductEvent is unsuccessful.',
        build: () {
          return productBloc;
        },
        setUp: () {
          when(mockGetSingleProduct(const GetParams(productId: testId)))
              .thenAnswer((_) async =>
                  const Left(ServerFailure(message: 'Some Error Message')));
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent(productId: testId)),
        expect: () => [
              ProductLoading(),
              const ProductErrorState(
                  message: Messages.productStatetErrorMessage)
            ]);
  });

  group('GetAllProductEvent', () {
    blocTest(
        'emits [LoadingState, LoadAllProductState] when LoadAllProductEvent is consumed',
        build: () {
          when(mockGetProduct(NoParams()))
              .thenAnswer((_) async => const Right([testProductEntitiy]));
          return productBloc;
        },
        act: (bloc) => bloc.add(GetAllProductEvent()),
        expect: () => [
              ProductLoading(),
              const LoadAllProductState(products: [testProductEntitiy])
            ]);
    blocTest(
        'emits [LoadingState, ErrorState] when LoadAllProductEvent is unsuccessful.',
        build: () {
          when(mockGetProduct(NoParams())).thenAnswer((_) async =>
              const Left(ServerFailure(message: Messages.serverError)));
          return productBloc;
        },
        act: (bloc) => bloc.add(GetAllProductEvent()),
        expect: () => [
              ProductLoading(),
              const ProductErrorState(
                  message: Messages.productStatetErrorMessage)
            ]);
    blocTest(
        'emits [LoadingState, ErrorState] when LoadAllProductEvent is unsuccessful.',
        build: () {
          when(mockGetProduct(NoParams())).thenAnswer((_) async =>
              const Left(CacheFailure(message: Messages.cacheError)));
          return productBloc;
        },
        act: (bloc) => bloc.add(GetAllProductEvent()),
        expect: () => [
              ProductLoading(),
              const ProductErrorState(
                  message: Messages.productStatetErrorMessage)
            ]);
  });

  group('CreateProductEvent', () {
    blocTest(
        'emits [LoadingState, LoadSingleProductState] when CreateProductEvent is added',
        build: () {
          when(mockInsertProduct(
                  const InsertParams(product: testProductEntitiy)))
              .thenAnswer((_) async => const Right(testProductEntitiy));
          return productBloc;
        },
        act: (bloc) =>
            bloc.add(const CreateProductEvent(product: testProductEntitiy)),
        expect: () => [
              ProductLoading(),
              const ProductCreatedState(product: testProductEntitiy)
            ]);

    blocTest(
        'emits [LoadingState, ErrorState] when CreateProductEvent is unsuccessful',
        build: () {
          when(mockInsertProduct(
                  const InsertParams(product: testProductEntitiy)))
              .thenAnswer((_) async =>
                  const Left(ServerFailure(message: Messages.serverError)));
          return productBloc;
        },
        act: (bloc) =>
            bloc.add(const CreateProductEvent(product: testProductEntitiy)),
        expect: () => [
              ProductLoading(),
              const ProductCreatedErrorState(
                  message: Messages.productStatetErrorMessage)
            ]);
  });

  group('UpdateProductEvent', () {
    blocTest(
        'emits [LoadingState, LoadSingleProductState] when UpdateProductEvent is added',
        build: () {
          when(mockUpdateProduct(
                  const UpdateParams(product: testProductEntitiy)))
              .thenAnswer((_) async => const Right(testProductEntitiy));
          return productBloc;
        },
        act: (bloc) =>
            bloc.add(const UpdateProductEvent(product: testProductEntitiy)),
        expect: () => [
              ProductLoading(),
              const ProductUpdatedState(product: testProductEntitiy)
            ]);

    blocTest(
        'emits [LoadingState, ErrorState] when UpdateProductEvent is unsuccessful',
        build: () {
          when(mockUpdateProduct(
                  const UpdateParams(product: testProductEntitiy)))
              .thenAnswer((_) async =>
                  const Left(ServerFailure(message: Messages.serverError)));
          return productBloc;
        },
        act: (bloc) =>
            bloc.add(const UpdateProductEvent(product: testProductEntitiy)),
        expect: () => [
              ProductLoading(),
              const ProductUpdatedErrorState(
                  message: Messages.productStatetErrorMessage)
            ]);
  });

  group('DeleteProductEvent', () {
    blocTest(
        'emits [LoadingState, ProductDeletedState] when DeleteProductEvent is added',
        build: () {
          when(mockDeleteProduct(const DeleteParams(productId: testId)))
              .thenAnswer((_) async => const Right(null));
          return productBloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent(productId: testId)),
        expect: () => [ProductLoading(), ProductDeletedState()]);

    blocTest(
        'emits [LoadingState, ErrorState] when DeleteProductEvent is unsuccessful',
        build: () {
          when(mockDeleteProduct(const DeleteParams(productId: testId)))
              .thenAnswer((_) async =>
                  const Left(ServerFailure(message: Messages.serverError)));
          return productBloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent(productId: testId)),
        expect: () => [
              ProductLoading(),
              const ProductErrorState(
                  message: Messages.productStatetErrorMessage)
            ]);
  });
}
