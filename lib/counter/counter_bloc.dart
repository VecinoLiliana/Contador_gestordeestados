import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterZero()) {
    on<Increment>((event, emit) {
      final newValue = state.counter + 1;
      if (newValue > 0) {
        emit(CounterPositive(newValue));
      } else if (newValue < 0) {
        emit(CounterNegative(newValue));
      } else {
        emit(const CounterZero());
      }
    });

    on<Decrement>((event, emit) {
      final newValue = state.counter - 1;
      if (newValue > 0) {
        emit(CounterPositive(newValue));
      } else if (newValue < 0) {
        emit(CounterNegative(newValue));
      } else {
        emit(const CounterZero());
      }
    });

    on<Reset>((event, emit) {
      emit(const CounterZero());
    });
  }
}
