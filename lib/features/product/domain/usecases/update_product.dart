import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct implements UseCase<Product, UpdateParams> {
  UpdateProduct(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, Product>> call(UpdateParams params) async {
    return await repository.updateProduct(params.product);
  }
}

class UpdateParams extends Equatable {
  const UpdateParams({required this.product});
  final Product product;
  @override
  List<Object?> get props => [product];
}
