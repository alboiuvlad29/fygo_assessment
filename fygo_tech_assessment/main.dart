import 'dart:io';

class DigitMapper {
  DigitMapper({required this.digits});

  final List<String> digits;
  List<String> _combinations = [];

  final Map<String, List<String>> _digitToCharMap = {
    '1': [''],
    '2': ['a', 'b', 'c'],
    '3': ['d', 'e', 'f'],
    '4': ['g', 'h', 'i'],
    '5': ['j', 'k', 'l'],
    '6': ['m', 'n', 'o'],
    '7': ['p', 'q', 'r', 's'],
    '8': ['t', 'u', 'v'],
    '9': ['w', 'x', 'y', 'z'],
  };

  List<String> result() {
    _combinations = [];
    _generateCombinations('', digits);
    return _combinations;
  }

  void _generateCombinations(String combination, List<String> digits) {
    if (digits.isEmpty) {
      _combinations.add(combination);
    } else {
      List<String> letters = _digitToCharMap[digits[0]]!;
      for (var letter in letters) {
        List<String> remaining = List.from(digits);
        remaining.removeAt(0);
        _generateCombinations(combination + letter, remaining);
      }
    }
  }
}

String readInput() {
  String? input;
  do {
    print('Insert string:');
    input = stdin.readLineSync();
  } while (input == null);

  if (input.length < 2 || input.length > 9) {
    print('The string\'s length has to be betwen 2 and 9.');
    return readInput();
  }

  RegExp exp = RegExp('([1-9])');
  if (!exp.hasMatch(input)) {
    print('The string can only contain numbers from 1 to 9.');
    return readInput();
  }
  return input;
}

void main() {
  String input = readInput();
  List<String> digits = input.split('');
  final mapper = DigitMapper(digits: digits);
  print(mapper.result());
}
