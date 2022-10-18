import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen{

  final spinkit = SpinKitSquareCircle(
    color: Colors.white,
    size: 50.0,
    controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
  );

  static Scaffold getLoadingScreen(){
    return Scaffold(
      body: Center(
        child: SpinKitCubeGrid(
          color: Colors.teal[300],
          size: 60
        )
      )
    );
  }
}