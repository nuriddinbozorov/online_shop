class CardModel {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final double balance;

  CardModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'balance': balance,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      cardNumber: map['cardNumber'],
      expiryDate: map['expiryDate'],
      cvv: map['cvv'],
      balance: map['balance'].toDouble(),
    );
  }
}
