import 'package:equatable/equatable.dart';

class AppError extends Equatable {
  final String message;
  final String? description;
  final Exception? exception;
  final StackTrace? stackTrace;
  late final int timestamp;

  AppError({
    required this.message,
    this.description,
    this.exception,
    this.stackTrace,
  }) {
    timestamp = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  List<Object?> get props =>
      [message, timestamp, description, exception, stackTrace];
}
