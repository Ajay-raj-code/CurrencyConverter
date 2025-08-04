import 'package:flutter/foundation.dart';

class CurrencySelector extends ChangeNotifier{
  List<Map<String, dynamic>> currency= [];
  Map<String,dynamic> _baseCurrency = {};
  Map<String,dynamic> _targetedCurrency = {};

  void loadCurrency(List<Map<String, dynamic>> list){
    currency = list;
    if(currency.isNotEmpty){
      _baseCurrency = list[1];
      _targetedCurrency = list[1];
    }
    notifyListeners();
  }

  Map<String,dynamic> get baseCurrency=> _baseCurrency;
  Map<String,dynamic> get targetedCurrency=> _targetedCurrency;

  void setBaseCurrency(Map<String , dynamic> value){
    _baseCurrency= value;
    notifyListeners();
  }

  void setTargetedCurrency(Map<String, dynamic> value){
    _targetedCurrency = value;
    notifyListeners();
  }


}

class AmountSelector extends ChangeNotifier{
  double _result = -1;
  double get result=>_result;
  void setResult(double value){
    _result = value;
    notifyListeners();
  }
}
