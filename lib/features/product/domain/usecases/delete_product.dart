import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProduct implements UseCase<void, DeleteParams> {
  DeleteProduct(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteParams params) async {
    return await repository.deleteProduct(params.productId);
  }
}

class DeleteParams extends Equatable {
  const DeleteParams({required this.productId});
  final String productId;

  @override
  List<Object?> get props => [productId];
}
