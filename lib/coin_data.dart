import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

//const coinAPIKey = '80D4B64F-BF8A-46AF-BAF6-A11AD9E67AEF';
const coinAPIKey = '4A45B086-0F1F-4C91-A682-535350AAEF0E';
const coinAPIUrl = 'https://rest.coinapi.io/v1/';

class CoinData {
  Future<String> getExchangeRate(String crypto, String currency) async {
    var res = await http
        .get('${coinAPIUrl}exchangerate/$crypto/$currency?apikey=$coinAPIKey');
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['rate']).toStringAsFixed(2);
    } else {
      print(res.body);
      return '0.0';
    }
  }
}
