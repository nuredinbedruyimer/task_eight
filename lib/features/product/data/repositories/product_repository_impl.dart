import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Product>> insertProduct(Product product) async {
    try {
      // Check if the device is connected to the internet
      if (await networkInfo.isConnected) {
        // Convert the Product entity to ProductModel
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );

        // Create the product remotely
        final newProduct = await remoteDataSource.createProduct(productModel);

        // Cache the product locally
        await localDataSource.cacheProduct(newProduct);

        // Return the newly created product
        return Right(newProduct.toEntity());
      } else {
        // Return a failure if there's no internet connection
        return const Left(ServerFailure(
            message: 'An error occurred while creating the product'));
      }
    } on ServerException {
      return const Left(ServerFailure(message: 'An error occurred'));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Failed to connect to the internet'));
    }
  }

  @override
  Future<Either<Failure, Product>> getSingleProduct(String productId) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteProduct = await remoteDataSource.fetchProduct(productId);
        if (remoteProduct != null) {
          await localDataSource.cacheProduct(remoteProduct);
          return Right(remoteProduct.toEntity());
        } else {
          return const Left(ServerFailure(message: 'Product not found'));
        }
      } else {
        final localProduct = await localDataSource.getCachedProduct(productId);
        if (localProduct != null) {
          return Right(localProduct.toEntity());
        } else {
          return const Left(CacheFailure(message: 'No cached product found'));
        }
      }
    } on ServerException {
      return const Left(ServerFailure(message: 'An error occurred'));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Failed to connect to the internet'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProduct() async {
    try {
      //  check connection issue and hamdle the case accordingly
      if (await networkInfo.isConnected) {
        // fetch list of remoteProducts Model
        final remoteProducts = await remoteDataSource.fetchAllProducts();
        await localDataSource.cacheProducts(remoteProducts);

        List<Product> remoteProductsEntity =
            remoteProducts.map((model) => model.toEntity()).toList();
        return Right(remoteProductsEntity);
      } else {
        final localProducts = await localDataSource.getAllCachedProducts();
        List<Product> localProductsEntity =
            localProducts.map((model) => model.toEntity()).toList();
        return Right(localProductsEntity);
      }
    } on ServerException {
      return const Left(ServerFailure(message: 'An error occurred'));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Failed to connect to the internet'));
    } on CacheException {
      return const Left(CacheFailure(message: 'An error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await remoteDataSource.deleteProductRemote(productId);
      return const Right(unit);
    } on ServerException {
      return const Left(ServerFailure(message: 'An error occurred'));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Failed to connect to the internet'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      final updatedProduct =
          await remoteDataSource.updateProductRemote(productModel);
      await localDataSource.cacheProduct(updatedProduct);
      return Right(updatedProduct.toEntity());
    } on ServerException {
      return const Left(ServerFailure(message: 'An error occurred'));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Failed to connect to the internet'));
    }
  }
}
