import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math show Random;

void main() => runApp(
      MaterialApp(
        title: "Flutter Bloc",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );

const names = [
  'Foo',
  'Bar',
  'Baz',
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);
  void pickRandomName() => emit(names.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;
  @override
  void initState() {
    cubit = NamesCubit();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Bloc"),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () {
              cubit.pickRandomName();
            },
            child: const Text('Pick Random Name'),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
              break;
            case ConnectionState.waiting:
              return button;
              break;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ""),
                  button,
                ],
              );
              break;
            case ConnectionState.done:
              return const SizedBox();
              break;
          }
        },
      ),
    );
  }
}
