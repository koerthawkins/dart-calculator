const allowedCharacters = ['+', '-', '*', '/', ' ', 'q', 'h', '\n'];
final computationMap = {
  '+': (double a, double b) => a + b,
  '-': (double a, double b) => a - b,
  '*': (double a, double b) => a * b,
  '/': (double a, double b) => a / b,
};

typedef ComputationFunction = double Function(double a, double b);

class Computation {
  double operand1;
  double operand2;
  ComputationFunction function;
  int nValidOperands;

  Computation(this.operand1, this.operand2, this.function)
      : nValidOperands = 3;

  Computation.empty()
      : operand1 = 0.0,
        operand2 = 0.0,
        function = computationMap['+']!,
        nValidOperands = 0;

  Computation.fromOneNumber(this.operand1)
      : operand2 = 0.0,
        function = computationMap['+']!,  // This is just any computation
        nValidOperands = 1;

  double? computeResult() {
    if (nValidOperands == 3) {
      return function(operand1, operand2);
    } else if (nValidOperands == 1) {
      return operand1;
    } else {
      return null;
    }
  }
}

class Calculator {
  double result;

  Calculator({String name = "Calculator", this.result = 0.0});

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
  Computation parseComputation(
      String computationString, double previousResult) {
    // Split the string input into its operands.
    List<String> operands = computationString.split(" ");

    // The default computation is an empty computation.
    var computation = Computation.empty();

    // TODO add more checks for numerics and non-numerics
    if (operands.length == 1) {
      if (isNumeric(operands.first)) {
        computation = Computation.fromOneNumber(double.parse(operands.first));
      } else {
        throw InvalidComputationException("You only supplied an operand!");
      }
    } else if (operands.length == 2) {
      if (!isNumeric(operands.first)) {
        computation = Computation(previousResult, double.parse(operands[1]),
            computationMap[operands[0]]!);
      }
    } else if (operands.length == 3) {
      // Here the first and third operands must be numbers.
      if (!isNumeric(operands.first) || !isNumeric(operands.last)) {
        throw InvalidComputationException(
            "Invalid computation! With 3 operands you need NUMBER FUNCTION NUMBER!");
      }

      computation = Computation(double.parse(operands[0]),
          double.parse(operands[2]), computationMap[operands[1]]!);
    } else {
      throw InvalidComputationException(
          "More than 3 operands are not supported!");
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

class InvalidComputationException implements Exception {
  String msg;

  InvalidComputationException(this.msg);

  @override
  String toString() {
    return "Wrong usage: $msg";
  }
}

/// See the tests in [dart_calculator_test.dart] for how to work with this.
extension X<T> on List<T> {
  List<T> everyNth(int n) => [for (var i = 0; i < length; i += n) this[i]];

  List<T> everyNthStartingWith(int n, int start) =>
      [for (var i = start; i < length; i += n) this[i]];
}
