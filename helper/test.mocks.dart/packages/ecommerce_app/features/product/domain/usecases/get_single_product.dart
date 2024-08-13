import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/product_repository.dart';

class GetSingleProduct {
  GetSingleProduct(this.repository);
  final ProductRepository repository;

  Future<Either<Failure, void>> call(String productId) async {
    return await repository.getSingleProduct(productId);
  }
}
