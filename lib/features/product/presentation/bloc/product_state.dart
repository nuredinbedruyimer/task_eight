part of 'product_bloc.dart';

//  it is just create the state of our feature(product)

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

//  The Intial State of our Product
class ProductInitialState extends ProductState {}

//  Loading State Of Our Product

class ProductLoading extends ProductState {}

//  Get(Load) All Product State
class LoadAllProductState extends ProductState {
  const LoadAllProductState({required this.products});
  final List<Product> products;

  @override
  List<Object> get props => [products];
}

// Load(Get) Single Product
class LoadSingleProductState extends ProductState {
  const LoadSingleProductState({required this.product});
  final Product product;

  @override
  List<Object> get props => [product];
}
//  Error State of Our Product Loading

class ProductErrorState extends ProductState {
  const ProductErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

//  Nothoing To Do in Case of Product Deleting Oprations

class ProductDeletedState extends ProductState {}

class ProductUpdatedState extends ProductState {
  const ProductUpdatedState({required this.product});
  final Product product;

  @override
  List<Object> get props => [product];
}

class ProductCreatedState extends ProductState {
  const ProductCreatedState({required this.product});
  final Product product;

  @override
  List<Object> get props => [product];
}

class ProductUpdatedErrorState extends ProductState {
  const ProductUpdatedErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class ProductCreatedErrorState extends ProductState {
  const ProductCreatedErrorState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
