part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class GetAllProductEvent extends ProductEvent {}

class GetSingleProductEvent extends ProductEvent {
  const GetSingleProductEvent({required this.productId});
  final String productId;

  @override
  List<Object> get props => [productId];
}

class UpdateProductEvent extends ProductEvent {
  const UpdateProductEvent({required this.product});
  final Product product;
  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  const DeleteProductEvent({required this.productId});
  final String productId;
  @override
  List<Object> get props => [productId];
}

class CreateProductEvent extends ProductEvent {
  const CreateProductEvent({required this.product});
  final Product product;

  @override
  List<Object> get props => [product];
}
