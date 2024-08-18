import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class InsertProduct implements UseCase<Product, InsertParams> {
  InsertProduct(this.repository);
  final ProductRepository repository;
  @override
  Future<Either<Failure, Product>> call(InsertParams params) async {
    return await repository.insertProduct(params.product);
  }
}

class InsertParams extends Equatable {
  const InsertParams({required this.product});

  final Product product;
  @override
  List<Object?> get props => [product];
}
