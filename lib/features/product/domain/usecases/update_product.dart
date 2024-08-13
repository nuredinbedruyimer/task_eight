import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  UpdateProduct(this.repository);
  final ProductRepository repository;

  Future<Either<Failure, void>> call(Product product) async {
    return await repository.updateProduct(product);
  }
}
