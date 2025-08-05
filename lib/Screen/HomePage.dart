import 'package:currency_converter/Models/HttpRequest.dart';
import 'package:currency_converter/Provider/Controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> exchangeRate;
  const HomePage({super.key, required this.exchangeRate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late  CurrencySelector currencySelectorProvider;
  late AmountSelector amountSelectorProvider;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currencySelectorProvider = Provider.of<CurrencySelector>(context, listen: false);
      amountSelectorProvider = Provider.of<AmountSelector>(context, listen: false);
      currencySelectorProvider.loadCurrency(widget.exchangeRate);

    });
  }
@override
  void dispose() {
    // TODO: implement dispose
  _controller.dispose();
  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
          style: TextStyle(color: Color(0xff055dcc)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "FROM",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            Consumer<CurrencySelector>(
              builder: (context, value, child) {
                return Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    menuMaxHeight: 500,

                    underline: SizedBox.shrink(),
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    value: value.baseCurrency,
                    items: value.currency
                        .map<DropdownMenuItem<Map<String, dynamic>>>((
                        baseCurrency,
                        ) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: baseCurrency,
                        child: Text(baseCurrency["currency"].toString(), style:const TextStyle(decoration: TextDecoration.none, fontSize: 19, fontWeight: FontWeight.normal),),
                      );
                    })
                        .toList(),
                    onChanged: (onChangeValue) {
                      value.setBaseCurrency(onChangeValue!);
                    },
                  ),
                );
              },
            ),
            const Spacer(),
            const Text(
              "TO",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            Consumer<CurrencySelector>(
              builder: (context, value, child) {
                return Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    menuMaxHeight: 500,

                    underline: SizedBox.shrink(),
                    isExpanded: true,
                    padding:const EdgeInsets.symmetric(horizontal: 15),
                    value: value.targetedCurrency,
                    items: value.currency
                        .map<DropdownMenuItem<Map<String, dynamic>>>((
                        targetedCurrency,
                        ) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: targetedCurrency,
                        child: Text(targetedCurrency["currency"].toString(), style:const TextStyle(decoration: TextDecoration.none, fontSize: 19, fontWeight: FontWeight.normal),),
                      );
                    })
                        .toList(),
                    onChanged: (onChangeValue) {
                      value.setTargetedCurrency(onChangeValue!);
                    },
                  ),
                );
              },
            ),
            const Spacer(),
            Consumer<CurrencySelector>(builder: (context, currency, child) {
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  currency.baseCurrency["key"] ?? "Null",
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.right,
                ),
              );
            },),
            Container(
              alignment: Alignment.centerLeft,
              height: 60,
              padding:const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(50),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                controller: _controller,
                keyboardType:const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration:const InputDecoration(
                  border:InputBorder.none,
                  hintText: "Amount",
                  hintStyle: TextStyle(fontSize: 20),

                ),
                style:const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                double base= double.parse(currencySelectorProvider.baseCurrency["value"].toString());
                double targeted= double.parse(currencySelectorProvider.targetedCurrency["value"].toString());
                double amount = double.parse(_controller.text.isEmpty ? "1": _controller.text.trim().toString());
                amountSelectorProvider.setResult((targeted/base)*amount);


              },
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff00d998),
                  borderRadius: BorderRadius.circular(15),
                ),
                child:const Text(
                  "Convert",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Result:",
                  style: TextStyle(fontSize: 19),
                  textAlign: TextAlign.right,
                ),
                Consumer<CurrencySelector>(builder: (context, currency, child) {
                  return Text(
                    currency.targetedCurrency["key"] ?? "Null",
                    style:const TextStyle(fontSize: 20),
                  );
                },),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(50),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Consumer<AmountSelector>(builder: (context, convertedResult, child) {
                return Text(convertedResult.result == -1? "Converted Amount": convertedResult.result.toStringAsFixed(2), style:const TextStyle(fontSize: 20));
              },),
            ),
            const Spacer(),
            const SizedBox(height: 10,),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
