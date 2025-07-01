import 'dart:io';

void routeValidatedInput({
  required String prompt,
  required Map<String, dynamic Function()> actions,
  String Function(String)? preprocess,
  String? errorMessage,
  String repeatSignal = 'REPEAT',
}) {
  String? input;
  final defaultError = '잘못된 입력입니다. ${actions.keys.join(', ')} 중에 하나를 선택해주세요.\n';

  do {
    stdout.write(prompt);
    input = stdin.readLineSync()?.trim() ?? '';
    final processedInput = preprocess != null ? preprocess(input) : input;

    if (actions.containsKey(processedInput)) {
      String? returnValue = actions[processedInput]!(); // 함수 실행
      if (returnValue == repeatSignal) {
        continue; // REPEAT 신호가 들어오면 다시 입력 받기
      }
      break;
    } else {
      print(errorMessage ?? defaultError);
    }
  } while (true);
}
