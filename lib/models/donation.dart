class Donation {
  final String recipientName;
  final double amount;

  Donation(this.recipientName, this.amount);

  Map<String, dynamic> toMap() {
    return {
      'recipientName': recipientName,
      'amount': amount,
    };
  }
}
