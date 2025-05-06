import 'dart:async';
import 'dart:convert';

import 'package:blockchain_upi/constants.dart';
import 'package:blockchain_upi/http/http.dart';
import 'package:blockchain_upi/screens/Trading/coin_card.dart';
import 'package:blockchain_upi/screens/Trading/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  bool loading = true;
  bool hide = false;
  List<Coin> coinList = [];
  SharedPreferences? prefs;

  void getprefs() async {
    prefs = await SharedPreferences.getInstance();

    hide = prefs!.getBool('hide') ?? false;
    fetchCoin();
  }

  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    var response = await HttpApiCalls().getBitcoin();
    final List<Map<String, dynamic>> res =
        List<Map<String, dynamic>>.from(json.decode(response));
    // print(res);

    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        //print('Id: ${res[i]['id']}, Symbol: ${res[i]['symbol']}');
        coinList.add(Coin(
          name: res[i]['name'],
          symbol: res[i]['symbol'],
          imageUrl: res[i]['image'],
          price: res[i]['current_price'],
          change: res[i]['price_change_24h'],
          changePercentage: res[i]['price_change_percentage_24h'],
          id: res[i]["id"],
          high_24h: res[i]["high_24h"].toString(),
          low_24h: res[i]["low_24h"].toString(),
        ));
      }
      //setState(() {});
      setState(() {
        loading = false;
        coinList;
      });
    }
    return coinList;
  }

  @override
  void initState() {
    getprefs();
    // Timer.periodic(const Duration(seconds: 10), (timer) => fetchCoin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 7, 55),
      appBar: AppBar(
        title: Text(
          "Trading",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 20, 7, 55),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hide
              ? const Center(
                  child: Text("Coin Trade Screen"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: coinList.length,
                  itemBuilder: (context, index) {
                    return CoinCard(
                      name: coinList[index].name,
                      symbol: coinList[index].symbol,
                      imageUrl: coinList[index].imageUrl,
                      price: coinList[index].price.toDouble(),
                      change: coinList[index].change.toDouble(),
                      changePercentage:
                          coinList[index].changePercentage.toDouble(),
                      id: coinList[index].id,
                      low_24h: coinList[index].low_24h,
                      high_24h: coinList[index].high_24h,
                    );
                  },
                ),
    );
  }
}
