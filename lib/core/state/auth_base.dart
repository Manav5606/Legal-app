import 'package:admin/data/models/models.dart';
import 'package:equatable/equatable.dart';

class StateBase extends Equatable {
  final AppError? error;

  const StateBase({this.error});
  @override
  List<Object?> get props => [error];
}
