part of 'sos_bloc.dart';

sealed class SosEvent extends Equatable {
  const SosEvent();

  @override
  List<Object?> get props => [];
}

class SosSubmitted extends SosEvent {
  final ReliefNeedType needType;
  final int peopleCount;
  final String? note;

  const SosSubmitted({
    required this.needType,
    required this.peopleCount,
    this.note,
  });

  @override
  List<Object?> get props => [needType, peopleCount, note];
}
