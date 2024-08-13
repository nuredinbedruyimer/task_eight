import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/product_repository.dart';

class GetProduct {
  GetProduct(this.repository);
  final ProductRepository repository;

  Future<Either<Failure, void>> call() async {
    return await repository.getProduct();
  }
}
