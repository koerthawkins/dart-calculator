import 'package:collection/collection.dart';

const allowedCharacters = ['+', '-', '*', '/', ' ', 'q', 'h', '\n'];
final computationMap = {
  '+': (num a, num b) => a + b,
  '-': (num a, num b) => a - b,
  '*': (num a, num b) => a * b,
  '/': (num a, num b) => a / b,
};

class Computation {
  List<List<dynamic>> computations;
  double previousResult;

  Computation(List<List<dynamic>> computations, double previousResult)
      : computations = computations,
        previousResult = previousResult {}

  double computeResult () {
    result = previousResult;
  }
}

int calculate() {
  return 6 * 7;
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

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

class NoPreviousResultException implements Exception {
  String msg;

  NoPreviousResultException(String msg) : msg = msg {}

  @override
  String toString() {
    return "Wrong usage: $msg";
  }
}

class TrailingOperandException implements Exception {
  String msg;

  TrailingOperandException(String msg) : msg = msg {}

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

List<List<dynamic>> parseComputation(String computationString,
    num? previousResult) {
  var computations = {
    'operands': [],
    'numbers': [],
  };

  List<String> operands = computationString.split(" ");

  if (operands.isNotEmpty) {
    // If previousResult is null, and the first operand
    // is an operator, that's invalid!
    if (previousResult == null && !isNumeric(operands.first)) {
      throw NoPreviousResultException(
          "You started your computation with an operator, but there's no previous result to use!");
    }

    // We use previousResults if it is non-null and the first operand
    // is an operator.
    if (previousResult != null && !isNumeric(operands.first)) {
      previousResult = operands.first;
      operands = operands.skip(1);
    }

    // The last operand may never be an operator.
    if (!isNumeric(operands.last)) {
      throw TrailingOperandException(
          "The last part of your computation may not be an operator (given: ${operands
              .last}!"
      );
    }

    // Now go through all the operands. Parse them such that computation_list
    // always starts with an operand.
    operands.forEachIndexed((index, element) {
      if (index.isEven) {
        // We have a number.
        if (index < operands.length - 1) {
          computations.add([element]);
        } else {

        }
      }
    })
    for (final operand in operands) {
      if (isNumeric(operand)) {
        computations['numbers']?.add(double.parse(operand));
      } else {
        computations['operands']?.add(computationMap[operand]);
      }
    }
  }

  return computations;
}
