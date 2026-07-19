import 'package:equatable/equatable.dart';

enum BaseStatus { initial, loading, loadingMore, success, failure }

abstract class BaseState extends Equatable {
  final BaseStatus status;
  final String errorMessage;

  final String? toastMessage;
  final int toastSeq;

  const BaseState({
    this.status = BaseStatus.initial,
    this.errorMessage = '',
    this.toastMessage,
    this.toastSeq = 0,
  });

  bool get isInitial => status == BaseStatus.initial;
  bool get isLoading => status == BaseStatus.loading;
  bool get isLoadingMore => status == BaseStatus.loadingMore;
  bool get isSuccess => status == BaseStatus.success;
  bool get isFailure => status == BaseStatus.failure;

  @override
  bool get stringify => true;

  List<Object?> get baseProps => [status, errorMessage, toastMessage, toastSeq];
}
