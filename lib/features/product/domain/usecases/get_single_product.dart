import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetSingleProduct implements UseCase<Product, GetParams> {
  GetSingleProduct(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, Product>> call(GetParams params) async {
    return await repository.getSingleProduct(params.productId);
  }
}

class GetParams extends Equatable {
  const GetParams({required this.productId});
  final String productId;
  @override
  List<Object?> get props => [productId];
}
