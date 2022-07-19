import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBloc<T, S> extends Bloc<T, S> {
  BaseBloc(S initialState) : super(initialState);

  Future<void> onAuthError() async {
    // emit(state)
  }
}
