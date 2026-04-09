
class Charger {
  int id;
  int requestId;
  int cardNo;
  int cvvNo;
  String expiryMonth;
  String expiryYear;
  String stripeToken;
  String amount;

  Charger({
    required this.id,
    required this.cardNo,
    required this.requestId,
    required this.cvvNo,
    required this.expiryMonth,
    required this.expiryYear,
    required this.stripeToken,
    required this.amount,

  });

  factory Charger.fromLocalJson( json) {
    return Charger(
      id: json['id'],
      cardNo: json['card[number]'],
      cvvNo: json['card[cvc]'],
      expiryMonth: json['card[exp_month]'],
      expiryYear: json['card[exp_year]'],
      stripeToken: json['stripe_token'],
      amount: json['amount'],
      requestId: json['charging_request_id'],

    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['card[number]'] = cardNo;
    data['card[cvc]'] = cvvNo;
    data['card[exp_month]'] = expiryMonth;
    data['card[exp_year]'] = expiryYear;
    data['stripe_token'] = stripeToken;
    data['amount'] = amount;
    data['charging_request_id'] = requestId;

    return data;
  }
}