import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/property/input_dialog.dart';
import 'package:flutter_teacher_logbook/property/property.dart';
import 'package:flutter_teacher_logbook/property/property_bloc.dart';
import 'package:flutter_teacher_logbook/property/property_event.dart';

import 'class/class_bloc.dart';
import 'class/class_event.dart';
import 'class/page.dart';
import 'fruit/fruit_bloc.dart';
import 'fruit/fruit_event.dart';
import 'fruit/home_page.dart';
import 'global.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('[event] $event');
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('[transition] $transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('[error] $error');
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Logbook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  static const PAGE_CLASS = 'Class';
  static const PAGE_FRUIT = 'Fruit';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentPage = MyHomePage.PAGE_CLASS;

  @override
  void initState() {
    super.initState();
    streamController.stream.listen((GlobalEvent event) {
      print('[GlobalEvent listen] $event');
      if (event == GlobalEvent.SwitchPageClass) {
        setState(() {
          currentPage = MyHomePage.PAGE_CLASS;
        });
      } else if (event == GlobalEvent.SwitchPageFruit) {
        setState(() {
          currentPage = MyHomePage.PAGE_FRUIT;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    print('Theme: ' + (isDark ? 'dark' : 'light'));
    return MultiBlocProvider(
        providers: [
          BlocProvider<FruitBloc>(
              create: (BuildContext context) => FruitBloc()..add(LoadFruits())),
          BlocProvider<ClassBloc>(
              create: (BuildContext context) => ClassBloc()..add(LoadClass())),
          BlocProvider<PropertyBloc>(
            create: (BuildContext context) =>
                PropertyBloc()..add(LoadProperty()),
          ),
        ],
        child: MaterialApp(
          title: 'Teacher Logbook',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            accentColor: Colors.redAccent,
          ),
          darkTheme: ThemeData.dark(),
          home: classOrFruit(),
//          home: PickerForm()),
        ));
  }

  Widget classOrFruit() {
    return currentPage == MyHomePage.PAGE_CLASS ? ClassPage() : FruitHomePage();
  }

  Scaffold pickerForm() {
    return Scaffold(
        appBar: AppBar(
          title: Text('PickerForm'),
        ),
        body: PickerForm(
            property: new Property(),
            onChange: (Property prop) {
              print('[asyncInputDialog] onChange: $prop');
            }));
  }
}
