import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/exception.dart';
import 'package:ecommerce_app/core/errors/failure.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test.mocks.mocks.dart';

void main() {
  late MockProductRemoteDataSource mockProductRemoteDataSource;
  late MockProductLocalDataSource mockProductLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  late ProductRepositoryImpl productRepositoryImpl;
  const testProductModelList = [
    ProductModel(
        id: '1',
        name: 'Nike',
        description: 'Nike is the best',
        price: 345.0,
        imageUrl: 'imageUrl')
  ];
  const testProductEntityList = [
    Product(
        id: '1',
        name: 'Nike',
        description: 'Nike is the best',
        price: 345.0,
        imageUrl: 'imageUrl')
  ];
  const testProductModel = ProductModel(
      id: '1',
      name: 'Nike',
      description: 'Nike is the best',
      price: 345.0,
      imageUrl: 'imageUrl');
  const testProductEntity = Product(
      id: '1',
      name: 'Nike',
      description: 'Nike is the best',
      price: 345.0,
      imageUrl: 'imageUrl');

  setUp(() {
    mockProductRemoteDataSource = MockProductRemoteDataSource();
    mockProductLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    productRepositoryImpl = ProductRepositoryImpl(
        remoteDataSource: mockProductRemoteDataSource,
        localDataSource: mockProductLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

// get product by id
  group('get Product', () {
    runTestsOnline(() {
      test('should return product when a call to data source is success ',
          () async {
        // arrange
        //  this part is ty to access remote data by using abstract product remote data sources
        // when yo call fetchDatasource using productRemoteDatasource it return Product Model because model if data layer image of product entities
        //  nned = testProductModel
        when(mockProductRemoteDataSource.fetchProduct('1'))
            .thenAnswer((_) async => testProductModel);
        // act
        final result = await productRepositoryImpl.getSingleProduct('1');
        //  what we have is product entities
        //  then we expect result and model.toEntity ti be same
        // assert
        expect(result, equals(const Right(testProductEntity)));
      });
    });
    runTestsOnline(() {
      test(
          'should return server faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.fetchProduct('1'))
            .thenThrow(ServerException());
        // act
        final result = await productRepositoryImpl.getSingleProduct('1');
        // assert
        expect(result, const Left(ServerFailure(message: 'An error occurred')));
      });
    });
    runTestsOnline(() {
      test(
          'should return connection  faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.fetchProduct('1')).thenThrow(
            const SocketException('Failed to connect to the internet'));
        // act
        final result = await productRepositoryImpl.getSingleProduct('1');
        // assert
        expect(
            result,
            const Left(ConnectionFailure(
                message: 'Failed to connect to the internet')));
      });
    });
  });

/* 
Delete Product function  Things we have to consider 
mae the process of deleting process in Distinict Steps

1 , Preparing the method signature like its return type , its Parameter and async or not
2 , Check the condition of the network and do two different task
    because we want to do deleting
     if there is no connection we have to handle ConnectionFailure
     else: we have to delete the product from the remote 
           we have to local deletion 
           we have to confirm the process success or failure




*/

  group('delete product', () {
    runTestsOnline(() {
      test('should delete product when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.deleteProductRemote('1'))
            .thenAnswer((_) async => (unit));
        // act
        final result = await productRepositoryImpl.deleteProduct('1');
        // assert
        expect(result, const Right(unit));
      });
    });

    runTestsOnline(() {
      test(
          'should return server faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.deleteProductRemote('1'))
            .thenThrow(ServerException());
        // act
        final result = await productRepositoryImpl.deleteProduct('1');
        // assert
        expect(result, const Left(ServerFailure(message: 'An error occurred')));
      });
    });

    runTestsOnline(() {
      test(
          'should return connection  faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.deleteProductRemote('1')).thenThrow(
            const SocketException('Failed to connect to the internet'));
        // act
        final result = await productRepositoryImpl.deleteProduct('1');
        // assert
        expect(
            result,
            const Left(ConnectionFailure(
                message: 'Failed to connect to the internet')));
      });
    });
  });

  // update product
  group('Update product', () {
    runTestsOnline(() {
      test('should update product when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.updateProductRemote(testProductModel))
            .thenAnswer((_) async => testProductModel);
        // act
        final result =
            await productRepositoryImpl.updateProduct(testProductModel);
        // assert
        expect(result, equals(const Right(testProductEntity)));
      });
    });

    runTestsOnline(() {
      test(
          'should return server faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.updateProductRemote(testProductModel))
            .thenThrow(ServerException());
        // act
        final result =
            await productRepositoryImpl.updateProduct(testProductModel);
        // assert
        expect(result, const Left(ServerFailure(message: 'An error occurred')));
      });
    });

    runTestsOnline(() {
      test(
          'should return connection  faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.updateProductRemote(testProductModel))
            .thenThrow(
                const SocketException('Failed to connect to the internet'));
        // act
        final result =
            await productRepositoryImpl.updateProduct(testProductModel);
        // assert
        expect(
            result,
            const Left(ConnectionFailure(
                message: 'Failed to connect to the internet')));
      });
    });
  });

  // create product
  group('create product', () {
    runTestsOnline(() {
      test('should create product when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.createProduct(testProductModel))
            .thenAnswer((_) async => testProductModel);
        // act
        final result =
            await productRepositoryImpl.insertProduct(testProductModel);
        // assert
        expect(result, equals(const Right(testProductEntity)));
      });
    });

    runTestsOnline(() {
      test(
          'should return server faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.updateProductRemote(testProductModel))
            .thenThrow(ServerException());
        // act
        final result =
            await productRepositoryImpl.updateProduct(testProductModel);
        // assert
        expect(result, const Left(ServerFailure(message: 'An error occurred')));
      });
    });
    runTestsOffline(() {
      test(
        'should return ServerFailure when device is offline and a server exception occurs',
        () async {
          // arrange
          when(mockProductRemoteDataSource.createProduct(testProductModel))
              .thenThrow(ServerException());
          when(mockProductLocalDataSource.cacheProduct(testProductModel)).thenThrow(
              CacheException()); // Optional if you want to simulate a cache failure

          // act
          final result =
              await productRepositoryImpl.insertProduct(testProductModel);

          // assert
          expect(
              result,
              const Left(ServerFailure(
                  message: 'An error occurred while creating the product')));
        },
      );
    });

    runTestsOnline(() {
      test(
          'should return connection  faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.createProduct(testProductModel))
            .thenThrow(
                const SocketException('Failed to connect to the internet'));
        // act
        final result =
            await productRepositoryImpl.insertProduct(testProductModel);
        // assert
        expect(
            result,
            const Left(ConnectionFailure(
                message: 'Failed to connect to the internet')));
      });
    });
  });

  //  get products
  group('get all products', () {
    runTestsOnline(() {
      test('should return products when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.fetchAllProducts())
            .thenAnswer((_) async => testProductModelList);
        // act
        final result = await productRepositoryImpl.getProduct();
        final unPackedResult =
            result.fold((failure) => null, (productList) => productList);
        // assert
        expect(unPackedResult, equals(testProductEntityList));
      });
    });

    runTestsOnline(() {
      test(
          'should cache products after getting them from the remote data source',
          () async {
        //arrange
        when(mockProductRemoteDataSource.fetchAllProducts())
            .thenAnswer((_) async => testProductModelList);
        when(mockProductLocalDataSource.cacheProducts(testProductModelList))
            .thenAnswer((_) async => unit);

        //act
        await productRepositoryImpl.getProduct();

        //assert
        verify(mockProductLocalDataSource.cacheProducts(testProductModelList));
      });
    });
    runTestsOffline(() {
      test('should return cached products when no network is available',
          () async {
        //arrange
        when(mockProductLocalDataSource.getAllCachedProducts())
            .thenAnswer((_) async => testProductModelList);

        //act
        final result = await productRepositoryImpl.getProduct();
        final unpackedResult =
            result.fold((failure) => null, (productList) => productList);

        //assert

        expect(unpackedResult, equals(testProductEntityList));
      });
    });

    runTestsOnline(() {
      test(
          'should return a server failure when a call to the remote data source is unsuccessful',
          () async {
        //arrange
        when(mockProductRemoteDataSource.fetchAllProducts())
            .thenThrow(ServerException());
        //act
        final result = await productRepositoryImpl.getProduct();

        //assert
        expect(result,
            equals(const Left(ServerFailure(message: 'An error occurred'))));
      });
    });
    runTestsOnline(() {
      test(
          'should return connection  faliure when a call to data source is success ',
          () async {
        // arrange
        when(mockProductRemoteDataSource.fetchAllProducts()).thenThrow(
            const SocketException('Failed to connect to the internet'));
        // act
        final result = await productRepositoryImpl.getProduct();
        // assert
        expect(
            result,
            const Left(ConnectionFailure(
                message: 'Failed to connect to the internet')));
      });
    });

    runTestsOffline(() {
      test('should return cache failure when failing to get cached products',
          () async {
        //arrange
        when(mockProductLocalDataSource.getAllCachedProducts())
            .thenThrow(CacheException());

        //act
        final result = await productRepositoryImpl.getProduct();

        //assert
        expect(result,
            equals(const Left(CacheFailure(message: 'An error occurred'))));
      });
    });
  });
}
