import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  double _sliderValue = 1.0;
  int _pickerValue = 0;

  void _showActionSheet(BuildContext context) {
    final bloc = context.read<CounterBloc>();
    
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Opciones del Contador'),
        message: const Text('Selecciona una acción'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              bloc.add(Increment());
              Navigator.pop(context);
            },
            child: const Text('Incrementar'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              bloc.add(Decrement());
              Navigator.pop(context);
            },
            child: const Text('Decrementar'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              bloc.add(Reset());
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: const Text('Resetear'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 50,
              color: CupertinoColors.systemGrey5.resolveFrom(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Confirmar'),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (int value) {
                  setState(() {
                    _pickerValue = value;
                  });
                },
                children: List<Widget>.generate(21, (int index) {
                  return Center(
                    child: Text(
                      '${index - 10}',
                      style: const TextStyle(fontSize: 22),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CounterBloc>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'BLoC Counter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 220, 29, 112),
          ),
        ),
        backgroundColor: Color.fromRGBO(249, 248, 248, 1),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.ellipsis_circle,
            color: Color.fromARGB(255, 220, 29, 112),
          ),
          onPressed: () => _showActionSheet(context),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Stack(
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
                          color = const Color.fromARGB(255, 220, 141, 155);
                        } else if (state is CounterNegative) {
                          message = ' ${state.counter}';
                          color = CupertinoColors.black;
                        } else {
                          message = '0';
                          color = CupertinoColors.systemGrey;
                        }

                        return Text(
                          message,
                          style: TextStyle(
                            fontSize: 140,
                            color: color,
                            decoration: TextDecoration.none,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // CupertinoSlider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Text(
                    'Incremento: ${_sliderValue.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      color: Color.fromARGB(255, 220, 141, 155),
                    ),
                  ),
                  CupertinoSlider(
                    value: _sliderValue,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Botones Cupertino
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // CupertinoButton Filled
                      CupertinoButton.filled(
                        onPressed: () {
                          for (int i = 0; i < _sliderValue.toInt(); i++) {
                            bloc.add(Decrement());
                          }
                        },
                        child: const Icon(CupertinoIcons.minus),
                      ),
                      
                      // CupertinoButton Tinted
                      CupertinoButton.tinted(
                        onPressed: () => bloc.add(Reset()),
                        child: const Icon(CupertinoIcons.refresh),
                      ),
                      
                      // CupertinoButton Filled
                      CupertinoButton.filled(
                        onPressed: () {
                          for (int i = 0; i < _sliderValue.toInt(); i++) {
                            bloc.add(Increment());
                          }
                        },
                        child: const Icon(CupertinoIcons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Botón para mostrar CupertinoPicker
                  CupertinoButton(
                    color: const Color.fromARGB(255, 220, 141, 155),
                    onPressed: () => _showPicker(context),
                    child: Text(
                      'Seleccionar Valor: ${_pickerValue - 10}',
                      style: const TextStyle(decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
