import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/pages/HomePage.dart';
import 'package:weather_app/route_generator.dart';

void main() {
        WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    //MultiProvider(
   // providers: [
   //   ChangeNotifierProvider(create: (_) => ModelViewModel()),
   // ],
   // child:
    const MyApp())/*)*/;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      onGenerateRoute: RouteGenerator.rotaOlustur,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
