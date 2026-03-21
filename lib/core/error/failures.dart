import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database error occurred.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Item not found.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}

class PdfFailure extends Failure {
  const PdfFailure([super.message = 'Failed to generate PDF.']);
}

class BackupFailure extends Failure {
  const BackupFailure([super.message = 'Backup operation failed.']);
}
