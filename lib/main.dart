import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:new_app/shared/bloc_observer.dart';
import 'layout/home.dart';


void main() {
 // Bloc.observer = MyBlocObserver();
  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      color: Colors.purpleAccent,
      theme: ThemeData(
        primaryColor: Colors.purpleAccent,
        //primarySwatch: Colors.purpleAccent,

      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

