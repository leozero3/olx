import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/route_generator.dart';
import 'package:olx/views/anuncios.dart';


final ThemeData temaPadrao = ThemeData(
  primaryColor: const Color(0xff9c27b0),
  accentColor: const Color(0xff7b1fa2)
);



void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'OLX',
    home: Anuncios(),
    theme: temaPadrao,
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
