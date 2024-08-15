import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exception.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class PoductRemoteDataSourceImpl implements ProductRemoteDataSource {
  PoductRemoteDataSourceImpl({required this.client});
  final http.Client client;

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    var uri = Uri.parse(Urls.baseUrl);

    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();

    //  this part is used to check url is sended if it is it accept and try to

    if (product.imageUrl.isNotEmpty) {
      //
      var productFileImage = File(product.imageUrl);
      if (productFileImage.existsSync()) {
        request.files
            .add(await http.MultipartFile.fromPath('image', product.imageUrl,
                contentType: MediaType(
                  'image',
                  'jpg',
                )));
      }
    } else {
      throw ImageException();
    }
    //  After Prepare the Data In Goof Way Now Let us Try to send the data to our
    //  remote data Source

    try {
      http.StreamedResponse streamedResponse = await request.send();
      if (streamedResponse.statusCode == 201) {
        final responseString = await streamedResponse.stream.bytesToString();
        final jsonResponse = json.decode(responseString);
        return ProductModel.fromJson(jsonResponse['data']);
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw const SocketException('Network Error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ProductModel?> fetchProduct(String productId) async {
    try {
      final response = await client.get(Uri.parse(Urls.getID(productId)));
      if (response.statusCode == 200) {
        //  convert to product Model from the returned json response
        return ProductModel.fromJson(json.decode(response.body)['data']);
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw const SocketException('Network Error');
    }
  }

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await client.get(Uri.parse(Urls.baseUrl));
      if (response.statusCode == 200) {
        // convert the response json to that of Product Model
        //  our response have many good product then waht am i try to do is

        return ProductModel.fromJsonList(json.decode(response.body)['data']);
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw const SocketException('Network Error');
    }
  }

  @override
  Future<ProductModel> updateProductRemote(ProductModel product) async {
    final productId = product.id;
    final jsonBody = jsonEncode({
      'name': product.name,
      'description': product.description,
      'price': product.price,
    });
    try {
      final response = await client.put(Uri.parse(Urls.getID(productId)),
          body: jsonBody, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return ProductModel.fromJson(json.decode(response.body)['data']);
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw const SocketException('Network Error');
    }
  }

  @override
  Future<void> deleteProductRemote(String productId) async {
    try {
      final response = await client.delete(Uri.parse(Urls.getID(productId)));
      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw const SocketException('Network Error');
    }
  }
}
