import '../model/balance_model.dart';

class BalanceApi {
  static Future<BalanceResponse> fetchBalance() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API

    final response = {
      "available_balance": 1245.0,
      "orders": 12,
      "tips": 140.0,
      "incentives": 220.0,
      "history": [
        {
          "order_id": "#ORD-78452",
          "amount": 85,
          "date": "30 Dec, 4:15 PM",
          "is_credit": true,
        },
        {
          "order_id": "#ORD-78421",
          "amount": 120,
          "date": "30 Dec, 2:10 PM",
          "is_credit": true,
        },
        {
          "order_id": "#ORD-78311",
          "amount": 60,
          "date": "29 Dec, 9:30 PM",
          "is_credit": false,
        },
      ],
    };

    return BalanceResponse.fromJson(response);
  }
}
