import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils.dart';

class LoadingScreen{

  final spinkit = const SpinKitSquareCircle(
    color: Colors.white,
    size: 50.0
  );

  static Scaffold getScreen(){
    return Scaffold(
      body: Center(
        child: SpinKitCubeGrid(
          color: DefaultColors.getDefaultColor(),
          size: 60
        )
      )
    );
  }
}