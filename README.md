# eCommerce Mobile App

This project is an eCommerce mobile application built using **Flutter**, following **Test-Driven Development (TDD)** and **Clean Architecture** principles.

## Tasks Overview

| **Task**                             | **Description**                                                                                                         |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| **Project Setup**                    | Initialized the Flutter project and set up TDD and Clean Architecture structure.                                         |
| **Product Entities**                 | Defined the `Product` entity in the domain layer, which includes attributes like `id`, `name`, `category`, `description`, and `price`. |
| **Use Cases**                        | Implemented use cases for inserting, updating, deleting, and getting products.                                           |
| **Repositories**                     | Defined repository interfaces for managing product data. Implemented the repository using local data sources.            |
| **Product Model**                    | Created the `ProductModel` class for JSON serialization, including `toJson` and `fromJson` methods.                      |
| **Testing**                          | Wrote unit tests for product use cases and models using `mockito`.                                                       |

## Folder Structure

| **Path**                             | **Description**                                                                                                         |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `lib/core/`                          | Contains core utilities and error handling (e.g., `failure.dart`, `database_failure.dart`, `server_failure.dart`).       |
| `lib/features/product/domain/`       | Holds the domain logic, including entities, use cases, and repository interfaces.                                        |
| `lib/features/product/data/`         | Contains data models and repository implementations.                                                                    |
| `test/features/product/domain/`      | Includes tests for domain layer use cases (`get_product_test.dart`, `delete_product_test.dart`).                         |
| `test/features/product/data/`        | Contains tests for data models and repository implementations.                                                          |

## Packages Used

| **Package**                                | **Description**                                                                                                         |
|--------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| **[equatable](https://pub.dev/packages/equatable)** | Simplifies value equality comparisons in Dart.                                                            |
| **[dartz](https://pub.dev/packages/dartz)**         | Provides functional programming constructs like `Either`.                                                    |
| **[mockito](https://pub.dev/packages/mockito)**     | A Dart package for creating mocks in unit tests.                                                            |
| **[build_runner](https://pub.dev/packages/build_runner)** | A build system for Dart code generation.                                                            |

## Installation

To install dependencies, add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  equatable: ^2.0.0
  dartz: ^0.10.1

dev_dependencies:
  mockito: ^5.1.0
  build_runner: ^2.1.7
