import 'dart:io';
import 'dart:collection';

import 'package:dart_calculator/dart_calculator.dart' as dart_calculator;

void main(List<String> arguments) async {
  // Indicate what the user can do.
  dart_calculator.printHelp();

  var calculator = dart_calculator.Calculator();

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

    // Handle the input.
    if (input == 'h') {
      dart_calculator.createHelp();
    } else if (input == 'q') {
      exit(0);
    } else if (calculator.inputIsValid(input)) {
      try {
        await calculator.computeNewResult(input);
      } on dart_calculator.InvalidComputationException catch (e, s) {
        print(e);
      }
    } else {
      calculator.printWrongUsage(input);
    }
  }

  exit(0);
}
