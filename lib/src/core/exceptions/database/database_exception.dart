import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

class DatabaseException extends Equatable implements Exception {
  late final String message;

  DatabaseException.fromIsarError(IsarError isarError)
      : message = isarError.message;

  @override
  List<Object?> get props => [message];
}
