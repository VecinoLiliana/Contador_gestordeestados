import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter/counter_bloc.dart';
import 'counter/counter_event.dart';
import 'counter/counter_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        primarySwatch: Colors.pink),
        home: BlocProvider(
        create: (_) => CounterBloc(),
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CounterBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text(
        'BLoC Counter', 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 60,
          color: Colors.white
        ),
      ), 
      backgroundColor: Colors.pink),

      body: Center(
        child:
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'lib/images/watchpink.png',
              width: 500, 
              height: 500,
              fit: BoxFit.cover, 
            ),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                String message;
                Color color;

                if (state is CounterPositive) {
                  message = ' ${state.counter}';
                  color = Colors.pinkAccent;
                } else if (state is CounterNegative) {
                  message = ' ${state.counter}';
                  color = Colors.black;
                } else {
                  message = '0';
                  color = Colors.grey;
                }

                return Text(
                  message,
                  style: TextStyle(fontSize: 140, color: color),
                );
              }
            )
          ],
        ),
      
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 300, right: 300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () => bloc.add(Decrement()),
              backgroundColor: Colors.pink, 
              foregroundColor: Colors.white,
              child: const Icon(Icons.remove), 
            ),
            
            FloatingActionButton(
              heroTag: 'reset',
              onPressed: () => bloc.add(Reset()),
              backgroundColor: Colors.pink, 
              foregroundColor: Colors.white,
              child: const Icon(Icons.refresh),
            ),
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: () => bloc.add(Increment()),
              backgroundColor: Colors.pink, 
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
