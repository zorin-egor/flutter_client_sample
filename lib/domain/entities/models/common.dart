
abstract class Container<Value> {
  Result when<Result>(
      Result Function(Data<Value>) data,
      Result Function(Empty) empty,
      Result Function(Error) error)
  {
    if (this is Data<Value>) {
      return data(this as Data<Value>);
    } else if (this is Empty) {
      return empty(this as Empty);
    } else if (this is Error) {
      return error(this as Error);
    } else {
      throw new Exception('Unhandled container');
    }
  }
}

class Empty extends Container<void> {}

class Data<T> extends Container<T> {
  final T value;
  Data(this.value);
}

class Error extends Container<void> {
  final Exception exception;
  Error(this.exception);
}
