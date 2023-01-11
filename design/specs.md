# Specifications for dart-calculator

## Brainstorm

- CLI application
- Initial version supports addition, subtraction, multiplication and division
- Package the code such that it can be re-used in a Flutter app
- Computations run in an isolate
- Previous results can be reused
  - Creating a new result: typing `3 + 4`
  - Re-using a previous result: typing `+ 4` only (omitting the first numerical value)
- Consider that every number in a web app is a double!
  - See [Numbers](https://dart.dev/guides/language/numbers)
  - **How to do:** treat every number in the calculator as a double!
- Options:
  - Computation operators:
    - `+`
    - `-`
    - `*`
    - `/`
  - Numbers
  - `SPACE`
  - `q` to quit
  - `ENTER` (or newline) to start computation
  - `h` for help
  - Everything else in the input is invalid!

## Specifications

### Development roadmap

- Develop the CLI interface which reacts correctly to the options
  - Computation operators shouldn't do anything at that point in time yet
- Parse the input s.t. it is split in computations to do
- Compute results synchronously
- Move the computation of results to an asynchronous isolate
- Implement the CI pipeline

### Tests

- Simple: Write a test for everything the app must do!
  - Correcting to CLI input
  - Parsing the input
  - Computing the results
- Write each test **directly** after the implementation of the feature it tests!

### CI

- Set up the Dart environment
- Build for multiple targets
  - EXE
  - JS
- Run tests