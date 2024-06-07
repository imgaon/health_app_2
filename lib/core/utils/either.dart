class Either<L, R> {
  bool isLeft() => this is Left<L, R>;
  bool isRight() => this is Right<L, R>;

  L left() => (this as Left<L, R>).value;
  R right() => (this as Right<L, R>).value;

  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    if (isLeft()) {
      return leftFn((this as Left<L, R>).value);
    } else {
      return rightFn((this as Right<L, R>).value);
    }
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;
  Left(this.value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  Right(this.value);
}