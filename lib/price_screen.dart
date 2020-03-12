import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'EUR';
  Map cryptoRates = Map();

  @override
  initState() {
    super.initState();
    getExchangeRates();
  }

  int getSelectedCurrencyIndex() {
    return currenciesList.indexOf(selectedCurrency);
  }

  void getExchangeRates({String currency}) async {
    Map rates = Map();
    for (String crypto in cryptoList) {
      rates[crypto] = await CoinData()
          .getExchangeRate(crypto, currency ?? selectedCurrency);
    }

    setState(() {
      if (currency != null) {
        selectedCurrency = currency;
      }
      cryptoRates = rates;
    });
  }

  DropdownButton androidCurrencyPicker() {
    return DropdownButton(
      value: selectedCurrency,
      items: currenciesList.map((String curr) {
        return DropdownMenuItem(
          child: Text(curr),
          value: curr,
        );
      }).toList(),
      onChanged: (value) {
//        setState(() {
//          selectedCurrency = value;
//        });
        getExchangeRates(currency: value);
      },
    );
  }

  CupertinoPicker iosCurrencyPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
//        setState(() {
//          selectedCurrency = currenciesList[selectedIndex];
//        });
        getExchangeRates(currency: currenciesList[selectedIndex]);
      },
      children: currenciesList.map((String curr) {
        return Text(curr);
      }).toList(),
      scrollController: FixedExtentScrollController(
        initialItem: getSelectedCurrencyIndex(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: cryptoRates.entries.map((MapEntry cryptoEntry) {
              return ExchangeCard(
                crypto: cryptoEntry.key,
                currency: selectedCurrency,
                rate: cryptoEntry.value,
              );
            }).toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Platform.isIOS ? iosCurrencyPicker() : androidCurrencyPicker(),
          ),
        ],
      ),
    );
  }
}

class ExchangeCard extends StatelessWidget {
  ExchangeCard({
    @required this.crypto,
    @required this.currency,
    this.rate = '?',
  });

  final String rate;
  final String crypto;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = $rate $currency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
