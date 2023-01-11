import 'dart:io';
import 'dart:collection';

import 'package:dart_calculator/dart_calculator.dart' as dart_calculator;

void main(List<String> arguments) async {
  // Indicate what the user can do.
  dart_calculator.createHelp();

  String? input = 'ENTER';

  while (input != 'q') {
    // Start the command prompt.
    stdout.write('> ');

    // Get input from user.
    input = stdin.readLineSync();

    // An input of null indicates something went wrong.
    if (input == null) {
      throw StdinException("Got invalid Null input!");
    }

    double? result;

    // Handle the input.
    if (input == 'h') {
      dart_calculator.createHelp();
    } else if (input == 'q') {
      exit(0);
    } else if (dart_calculator.inputIsValid(input)) {
      try {
        // Parse the computation into a list.
        // The list starts and ends with a double, and if there was a previous
        // result the first number automatically is the previous result.
        var computationList = dart_calculator.parseComputation(input, result);

        // Compute the result.
        Iterable operators = computationList.where((element) => element.runtimeType == String);
        Iterable numbers = computationList.where((element) => element.runtimeType == double);
        result = numbers.first;
        numbers = numbers.skip(1);

        // for (final pairs in IterableZip([operators, numbers[0:-1], numbers[]])) {
        //   c.add(Foo(pairs[0], pairs[1]));
        // }
      } on dart_calculator.NoPreviousResultException catch (e, s) {
        print(e);
      } on dart_calculator.TrailingOperandException catch (e, s) {
        print(e);
      }
    } else {
      dart_calculator.printWrongUsage(input);
    }
  }
}
