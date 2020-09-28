import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AutoLoadCubit<T> extends Cubit<T> {
  AutoLoadCubit({T state}) : super(state) {
    if (state == null) {
      final FutureOr<T> initialState = loadInitialState();
      if (initialState is Future<T>) {
        initialState.then(emit);
      } else if (initialState is T) {
        
        emit(initialState);
      }
    }
  }

  FutureOr<T> loadInitialState();
}
