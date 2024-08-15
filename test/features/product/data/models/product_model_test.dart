import 'dart:convert';

import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/helpers.json_reader.dart';

void main() {
  //  it just test the given data we have is subclass of product entities

  const testProductModel = ProductModel(
    id: '1',
    name: 'Product Number One',
    description: 'Description One',
    price: 1320.0,
    imageUrl: 'http://nuredin.com/image1',
  );
  test('Should be subclas of product entity', () async {
    // this part is just checking the given data is subclass of product
    // entities it can ignore value but not add value
    // assert

    expect(testProductModel, isA<Product>());
  });

  test(
    'should return a valid product model from json',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_product_json_response.json'),
      );

      // act
      final result = ProductModel.fromJson(jsonMap);

      // assert
      expect(result, equals(testProductModel));
    },
  );
  test(
    'should return a json map containing proper data after converting the product model to json format',
    () async {
      // act
      final result = jsonEncode(testProductModel.toJson());
      // assert
      final expectedJsonMap = {
        'id': '1',
        'name': 'Product Number One',
        'description': 'Description One',
        'price': 1320.0,
        'imageUrl': 'http://nuredin.com/image1',
      };

      expect(result, jsonEncode(expectedJsonMap));
    },
  );
}
