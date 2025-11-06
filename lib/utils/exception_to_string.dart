class ExceptionToString implements Exception {
  final String message;
  ExceptionToString(this.message);

  @override
  String toString() => message;
}