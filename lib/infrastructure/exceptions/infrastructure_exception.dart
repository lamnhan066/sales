abstract class InfrastructureException implements Exception {

  const InfrastructureException(this.message, [this.stackTrace]);
  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'InfrastructureException(message: $message, stackTrace: $stackTrace)';
}
