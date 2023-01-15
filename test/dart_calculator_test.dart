import 'package:dart_calculator/dart_calculator.dart';
import 'package:test/test.dart';

// Dart testing allows for:
//   - unit tests
//   - component tests (or widget tests in Flutter)
//     test a component, which is usually a collection of classes
//     often requires the use of a mock object
//   - integration of end-to-end tests
//     usually run on a real or simulated device
//     consist of the app itself and the test app
//     often measures performance too

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });

  test('help', () {
    expect(createHelp(), startsWith('Usage'));
  });
}
