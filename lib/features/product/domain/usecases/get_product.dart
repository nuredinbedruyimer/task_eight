import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProduct implements UseCase<List<Product>, NoParams> {
  GetProduct(this.repository);
  final ProductRepository repository;
  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getProduct();
  }
}
