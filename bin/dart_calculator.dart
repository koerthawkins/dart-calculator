import 'dart:io';
import 'dart:collection';

import 'package:dart_calculator/dart_calculator.dart' as dart_calculator;

void main(List<String> arguments) async {
  // Indicate what the user can do.
  dart_calculator.createHelp();

  String? input = 'ENTER';

  double result = 0.0;

  while (input != 'q') {
    // Start the command prompt.
    stdout.write('> ');

    // Get input from user.
    input = stdin.readLineSync();

    // An input of null indicates something went wrong.
    if (input == null) {
      throw StdinException("Got invalid Null input!");
    }

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
        var computation = dart_calculator.parseComputation(input, result);

        // Compute the result of the current computation.
        double? newResult = computation.computeResult();
        if (newResult != null) {
          result = newResult;
          print(result);
        } else {
        }

      } on dart_calculator.InvalidComputationException catch (e, s) {
        print(e);
      }
    } else {
      dart_calculator.printWrongUsage(input);
    }
  }
}
