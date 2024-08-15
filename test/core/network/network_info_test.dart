import 'package:ecommerce_app/core/network/network_info_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test.mocks.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  // Setting up the test environment
  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test('should return true when there is an internet connection', () async {
      // Arrange: Mocking the InternetConnectionChecker to return true
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => Future.value(true));

      // Act: Calling the isConnected method
      final result = await networkInfo.isConnected;

      // Assert: Verifying the result is true and that hasConnection was called
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, true);
    });

    test('should return false when there is no internet connection', () async {
      // Arrange: Mocking the InternetConnectionChecker to return false
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);

      // Act: Calling the isConnected method
      final result = await networkInfo.isConnected;

      // Assert: Verifying the result is false and that hasConnection was called
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, false);
    });
  });
}
