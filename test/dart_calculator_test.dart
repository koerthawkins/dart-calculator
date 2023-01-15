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
  // Test whether the help string is (or seems) valid.
  test('createHelp() returns valid help', () {
    expect(createHelp(), startsWith('Usage'));
  });

  // Test whether there are all supported operators in computationMap.
  group('all supported operators are in computationMap', () {
    test ('+', () {
      expect(computationMap.keys, contains('+'));
    });
    test ('-', () {
      expect(computationMap.keys, contains('+'));
    });
    test ('*', () {
      expect(computationMap.keys, contains('+'));
    });
    test ('/', () {
      expect(computationMap.keys, contains('+'));
    });
  });

  // Test whether the Computation constructors work correctly.
  group('the constructors for Computation work correctly', () {
    test('Computation()', () {
      var computation = Computation(1.5, 2.5, computationMap['-']!);

      expect(computation.operand1, equals(1.5));
      expect(computation.operand2, equals(2.5));
      expect(computation.function, equals(computationMap['-']));
      expect(computation.nValidOperands, equals(3));
    });

    test('Computation.fromOneNumber()', () {
      var computation = Computation.fromOneNumber(1.5);

      expect(computation.operand1, equals(1.5));
      expect(computation.operand2, equals(0.0));
      expect(computation.nValidOperands, equals(1));
    });

    test('Computation.empty()', () {
      var computation = Computation.empty();

      expect(computation.operand1, equals(0.0));
      expect(computation.operand2, equals(0.0));
      expect(computation.nValidOperands, equals(0));
    });
  });

  test('Computation.computeResult() returns correct results', () {
    var computation = Computation(2.0, 4.0, computationMap['+']!);
    expect(computation.computeResult(), equals(6.0));

    computation = Computation(2.0, 4.0, computationMap['-']!);
    expect(computation.computeResult(), equals(-2.0));

    computation = Computation(2.0, 4.0, computationMap['*']!);
    expect(computation.computeResult(), equals(8.0));

    computation = Computation(2.0, 4.0, computationMap['/']!);
    expect(computation.computeResult(), equals(0.5));
  });

  test('isNumeric()', () {
    expect(isNumeric('3.0'), equals(true));
    expect(isNumeric('-3.0'), equals(true));
    expect(isNumeric('3'), equals(true));
    expect(isNumeric('-3'), equals(true));

    expect(isNumeric('meow'), equals(false));
    expect(isNumeric('+'), equals(false));
    expect(isNumeric('*'), equals(false));
    expect(isNumeric(''), equals(false));
    expect(isNumeric(' '), equals(false));
    expect(isNumeric('q'), equals(false));
    expect(isNumeric('h'), equals(false));
  });

  test('everyNth', () {
    expect([1, 2, 3, 4, 5].everyNth(2), equals([1, 3, 5]));
    expect([1, 2, 3, 4, 5].everyNth(3), equals([1, 4]));
  });

  test('everyNthStartingWith', () {
    expect([1, 2, 3, 4, 5].everyNthStartingWith(2, 0), equals([1, 3, 5]));
    expect([1, 2, 3, 4, 5].everyNthStartingWith(2, 1), equals([2, 4]));
    expect([1, 2, 3, 4, 5].everyNthStartingWith(2, 2), equals([3, 5]));
  });
}
