import 'package:currency_converter/Models/HttpRequest.dart';
import 'package:currency_converter/Provider/Controllers.dart';
import 'package:currency_converter/Screen/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late List<Map<String, dynamic>> exchangeRate;
void main() async {

  exchangeRate = await ExchangeResponse();

  runApp( MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CurrencySelector(),),
    ChangeNotifierProvider(create: (context) => AmountSelector(),),
  ], child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: HomePage(exchangeRate: exchangeRate,),
    );
  }
}

