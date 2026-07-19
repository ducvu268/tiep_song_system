import 'package:bloc/bloc.dart';
import 'package:tiep_song/common/errors/app_exception.dart';
import 'package:tiep_song/common/logger/app_logger.dart';

import 'base_state.dart';

export 'base_state.dart';

abstract class BaseBloc<E, S extends BaseState> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  Future<void> runSafely(
    Emitter<S> emit,
    Future<void> Function() handler, {
    void Function(AppException e)? onError,
  }) async {
    try {
      await handler();
    } on AppException catch (e, stack) {
      _handleError(emit, e, stack, onError);
    } catch (e, stack) {
      _handleError(emit, UnknownException(e.toString()), stack, onError);
    }
  }

  void _handleError(
    Emitter<S> emit,
    AppException e,
    StackTrace stack,
    void Function(AppException e)? onError,
  ) {
    AppLogger.error('[$runtimeType]', e, stack);
    if (onError != null) {
      onError(e);
    } else {
      emit(buildFailureState(e.message));
    }
  }

  S buildFailureState(String message);
}
