import 'package:collection/collection.dart';

const allowedCharacters = ['+', '-', '*', '/', ' ', 'q', 'h', '\n'];
final computationMap = {
  '+': (double a, double b) => a + b,
  '-': (double a, double b) => a - b,
  '*': (double a, double b) => a * b,
  '/': (double a, double b) => a / b,
};

typedef double ComputationFunction(double a, double b);

class Computation {
  double operand1;
  double operand2;
  ComputationFunction function;
  int nValidOperands;

  Computation(double operand1, double operand2, ComputationFunction function) : operand1 = operand1, operand2 = operand2, function = function, nValidOperands = 3;
  Computation.empty() : operand1 = 0.0, operand2 = 0.0, function = computationMap['+']!, nValidOperands = 0;
  Computation.fromOneNumber(double operand1) : operand1 = operand1, operand2 = 0.0, function = computationMap['+']!, nValidOperands = 1;

  double? computeResult () {
    if (nValidOperands == 3) {
      return function(operand1, operand2);
    } else if (nValidOperands == 1) {
      return operand1;
    } else {
      return null;
    }
  }
}

int calculate() {
  return 6 * 7;
}

class Calculator {
  String _name;
  double result;

  Calculator({String name = "Calculator", double result = 0.0}) : _name = name, result = result {}

  bool inputIsValid(String input) {
    // We don't want to change the actual input.
    var inputCopy = input;

    // Remove all allowed characters from input.
    for (final allowedCharacter in allowedCharacters) {
      inputCopy = inputCopy.replaceAll(allowedCharacter, '');
    }

    // Remove all numerics from input.
    inputCopy = inputCopy.replaceAll(RegExp(r"\d"), "");

    // After removing the allowed characters the input must be empty.
    return inputCopy.isEmpty ? true : false;
  }

  void printWrongUsage(String input) {
    print('Got invalid input: $input');
    createHelp();
  }

  /// Parse a computation input.
  ///
  /// For now we limit the input to a maximum of 2 numbers and 1 operand. This
  /// way operator precedence can be neglected for now, which makes everything
  /// easier.
  Computation parseComputation(String computationString,
      double previousResult) {
    // Split the string input into its operands.
    List<String> operands = computationString.split(" ");

    var computation;
    // TODO add more checks for numerics and non-numerics
    if (operands.isEmpty || operands.first == '') {
      computation = Computation.empty();
    } else if (operands.length == 1) {
      if (isNumeric(operands.first)) {
        computation = Computation.fromOneNumber(double.parse(operands.first));
      } else {
        throw InvalidComputationException(
            "You only supplied an operand!"
        );
      }
    } else if (operands.length == 2) {
      if (!isNumeric(operands.first)) {
        computation = Computation(previousResult, double.parse(operands[1]), computationMap[operands[0]]!);
      }
    }
    else if (operands.length == 3) {
      // Here the first and third operands must be numbers.
      if (!isNumeric(operands.first) || !isNumeric(operands.last)) {
        throw InvalidComputationException(
            "Invalid computation! With 3 operands you need NUMBER FUNCTION NUMBER!"
        );
      }

      computation = Computation(double.parse(operands[0]), double.parse(operands[2]), computationMap[operands[1]]!);
    } else {
      throw InvalidComputationException(
          "More than 3 operands are not supported!"
      );
    }

    return computation;
  }

  void computeNewResult(String input, {bool printResult = true}) {
    // Parse the computation into a list.
    // The list starts and ends with a double, and if there was a previous
    // result the first number automatically is the previous result.
    var computation = parseComputation(input, result);

    // Compute the result of the current computation.
    // Only store the new result if it is valid.
    double? newResult = computation.computeResult();
    if (newResult != null) {
      result = newResult;
      if (printResult) {
        print(result);
      }
    }
  }
}

void printHelp() {
  print(createHelp());
}

String createHelp() {
  return 'Usage:\n'
      '\t- `h`: print help\n'
      '\t- `+-*/`: operators\n'
      '\t- `q`: quit';
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

// class NoPreviousResultException implements Exception {
//   String msg;
//
//   NoPreviousResultException(String msg) : msg = msg {}
//
//   @override
//   String toString() {
//     return "Wrong usage: $msg";
//   }
// }
//
// class TrailingOperandException implements Exception {
//   String msg;
//
//   TrailingOperandException(String msg) : msg = msg {}
//
//   @override
//   String toString() {
//     return "Wrong usage: $msg";
//   }
// }

class InvalidComputationException implements Exception {
  String msg;

  InvalidComputationException(String msg) : msg = msg {}

  @override
  String toString() {
    return "Wrong usage: $msg";
  }
}

extension X<T> on List<T> {
  List<T> everyNth(int n) => [for (var i = 0; i < length; i += n) this[i]];

  List<T> everyNthStartingWith(int n, int start) =>
      [for (var i = start; i < length; i += n) this[i]];
}

// List<List<dynamic>> parseComputation(String computationString,
//     num? previousResult) {
//   var computations = {
//     'operands': [],
//     'numbers': [],
//   };
//
//   List<String> operands = computationString.split(" ");
//
//   if (operands.isNotEmpty) {
//     // If previousResult is null, and the first operand
//     // is an operator, that's invalid!
//     if (previousResult == null && !isNumeric(operands.first)) {
//       throw NoPreviousResultException(
//           "You started your computation with an operator, but there's no previous result to use!");
//     }
//
//     // We use previousResults if it is non-null and the first operand
//     // is an operator.
//     if (previousResult != null && !isNumeric(operands.first)) {
//       previousResult = operands.first;
//       operands = operands.skip(1);
//     }
//
//     // The last operand may never be an operator.
//     if (!isNumeric(operands.last)) {
//       throw TrailingOperandException(
//           "The last part of your computation may not be an operator (given: ${operands
//               .last}!"
//       );
//     }
//
//     // Now go through all the operands. Parse them such that computation_list
//     // always starts with an operand.
//     operands.forEachIndexed((index, element) {
//       if (index.isEven) {
//         // We have a number.
//         if (index < operands.length - 1) {
//           computations.add([element]);
//         } else {
//
//         }
//       }
//     })
//     for (final operand in operands) {
//       if (isNumeric(operand)) {
//         computations['numbers']?.add(double.parse(operand));
//       } else {
//         computations['operands']?.add(computationMap[operand]);
//       }
//     }
//   }
//
//   return computations;
// }
