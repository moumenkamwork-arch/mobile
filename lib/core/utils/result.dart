import '../errors/app_failure.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;

  const factory Result.failure(AppFailure failure) = Failure<T>;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Failure<T>(failure: final error) => failure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Success<T> &&
            runtimeType == other.runtimeType &&
            data == other.data;
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Failure<T> &&
            runtimeType == other.runtimeType &&
            failure == other.failure;
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);
}
