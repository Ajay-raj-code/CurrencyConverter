import 'dart:convert';

import 'package:currency_converter/Const/CurrencyLIstWIthCode.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String,dynamic>>> ExchangeResponse()async {
  final response = await http.get(Uri.parse("https://v6.exchangerate-api.com/v6/11b3e696c83118a19952d4b4/latest/USD"));
  if(response.statusCode == 200){
    final fetchedData = jsonDecode(response.body);
    List<Map<String ,dynamic>> list = fetchedData["conversion_rates"].entries.map<Map<String, dynamic>>((e)=> {
      "key":e.key,
      "value":e.value,
      "currency":Currency.CurrencyWithCode[e.key] ?? "Unknown",
    }).toList();

    return list;

  }else if(response.statusCode == 404){
    return [];
  }
  return [];
}