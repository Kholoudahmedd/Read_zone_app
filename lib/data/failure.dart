abstract class Failure {
  final String message;
  const Failure(this.message);
  
  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error']) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = 'Network error']) : super(message);
}

class DataParsingFailure extends Failure {
  DataParsingFailure([String message = 'Data parsing error']) : super(message);
}