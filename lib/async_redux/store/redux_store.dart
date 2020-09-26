import 'package:async_redux/async_redux.dart';
import 'package:flutter_todos_app/async_redux/store/app_state.dart';

final store = Store<AppState>(initialState: AppState.initialState());
