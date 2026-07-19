part of 'sos_list_bloc.dart';

class SosListState extends BaseState {
  final List<SosRequest> items;

  const SosListState({
    super.status = BaseStatus.initial,
    super.errorMessage = '',
    super.toastMessage,
    super.toastSeq = 0,
    this.items = const [],
  });

  SosListState copyWith({
    BaseStatus? status,
    String? errorMessage,
    String? toastMessage,
    int? toastSeq,
    List<SosRequest>? items,
  }) => SosListState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    toastMessage: toastMessage ?? this.toastMessage,
    toastSeq: toastSeq ?? this.toastSeq,
    items: items ?? this.items,
  );

  @override
  List<Object?> get props => [...baseProps, items];
}
