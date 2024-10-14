abstract class InfrastructureException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const InfrastructureException(this.message, [this.stackTrace]);

  @override
  String toString() => 'InfrastructureException(message: $message, stackTrace: $stackTrace)';
}
