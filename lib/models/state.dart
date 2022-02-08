class State<T> {
  State._(); // private constructor
  factory State.success(T value) = SuccessState<T>;

  factory State.error(T msg) = ErrorState<T>;
}

class ErrorState<T> extends State<T> {
  ErrorState(this.value) : super._();
  final T value;
}

class SuccessState<T> extends State<T> {
  SuccessState(this.value) : super._();
  final T value;
}
