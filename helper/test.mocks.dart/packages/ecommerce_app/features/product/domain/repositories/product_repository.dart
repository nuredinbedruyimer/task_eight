import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Product>> insertProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String productId);
  Future<Either<Failure, List<Product>>> getProduct();
  Future<Either<Failure, Product>> getSingleProduct(String productId);
}
