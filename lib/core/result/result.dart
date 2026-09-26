sealed class Result<T, E extends Exception> {
  const Result();
}

class Success<T, E extends Exception> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

class Failure<T, E extends Exception> extends Result<T, E> {
  const Failure(this.error);
  final E error;
}

class AppError implements Exception {
  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
}

class DatabaseError extends AppError {
  const DatabaseError(super.message);
}

class NetworkError extends AppError {
  const NetworkError(super.message);
}
