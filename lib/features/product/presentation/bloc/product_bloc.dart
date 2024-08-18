import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/get_single_product.dart';
import '../../domain/usecases/insert_product.dart';
import '../../domain/usecases/update_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._getProduct, this._getSingleProductEvent,
      this._updateProduct, this._deleteProduct, this._insertProduct)
      : super(ProductInitialState()) {
    on<GetSingleProductEvent>((event, emit) async {
      emit(ProductLoading());
      final data =
          await _getSingleProductEvent(GetParams(productId: event.productId));

      data.fold(
          (failure) =>
              emit(const ProductErrorState(message: 'Some Message Here ')),
          (product) => emit(LoadSingleProductState(product: product)));
    });

    // Get All Product Event Handler

    on<GetAllProductEvent>((event, emit) async {
      emit(ProductLoading());
      final datas = await _getProduct(NoParams());
      datas.fold(
          (failure) =>
              emit(const ProductErrorState(message: 'Some Error Message')),
          (products) => emit(LoadAllProductState(products: products)));
    });
    on<UpdateProductEvent>((event, emit) async {
      emit(ProductLoading());
      final data = await _updateProduct(UpdateParams(product: event.product));

      data.fold(
        (failure) =>
            emit(const ProductErrorState(message: 'Some Error Message')),
        (product) => emit(ProductUpdatedState(product: product)),
      );
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());
      final data =
          await _deleteProduct(DeleteParams(productId: event.productId));
      data.fold(
          (failure) =>
              emit(const ProductErrorState(message: 'Some Error Messafe')),
          (product) => ProductDeletedState());
    });

    on<CreateProductEvent>((event, emit) async {
      emit(ProductLoading());
      final data = await _insertProduct(InsertParams(product: event.product));
      data.fold(
          (failure) => emit(
              const ProductCreatedErrorState(message: 'Some Error Message')),
          (product) => emit(ProductCreatedState(product: product)));
    });
  }
  final GetProduct _getProduct;
  final GetSingleProduct _getSingleProductEvent;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;
  final InsertProduct _insertProduct;
}
