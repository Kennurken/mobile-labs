// Зертханалық сабақ №11. Unit-тест: калькулятор және ToDo бизнес-логикасы.

int add(int a, int b) => a + b;
int multiply(int a, int b) => a * b;
int subtract(int a, int b) => a - b;

/// Нөлге бөлуге болмайды.
double divide(num a, num b) {
  if (b == 0) throw ArgumentError('Нөлге бөлуге болмайды');
  return a / b;
}
