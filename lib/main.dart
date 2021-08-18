import 'package:flutter/material.dart';
import 'layOut/HomeLayout.dart';
import 'package:bloc/bloc.dart';
import 'bloc/cubit/cubit.dart';
import 'modules/constant.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout(),
    );
  }
}
