import 'package:equatable/equatable.dart';

abstract class CounterState extends Equatable {
  final int counter;
  const CounterState(this.counter);

  @override
  List<Object?> get props => [counter];
}

class CounterPositive extends CounterState {
  const CounterPositive(int counter) : super(counter);
}

class CounterNegative extends CounterState {
  const CounterNegative(int counter) : super(counter);
}

class CounterZero extends CounterState {
  const CounterZero() : super(0);
}
