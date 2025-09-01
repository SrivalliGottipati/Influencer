class WalletSummary {
  WalletSummary({required this.balance});
  final double balance;
  factory WalletSummary.mock() => WalletSummary(balance: 12550);
}

class WalletTxn {
  WalletTxn({required this.title, required this.date, required this.amount});
  final String title;
  final String date;
  final double amount;
}
