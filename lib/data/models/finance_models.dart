import 'package:flutter/material.dart';

enum TransactionType {
  referral,
  videoEarning,
  withdrawal,
  deposit,
  bonus,
  penalty,
  refund,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime date;
  final String? referenceId;
  final String? notes;
  final Color? typeColor;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
    this.referenceId,
    this.notes,
    this.typeColor,
  });

  bool get isCredit => amount > 0;
  bool get isDebit => amount < 0;

  String get formattedAmount => '₹${amount.abs().toStringAsFixed(2)}';
  String get statusText => status.name.toUpperCase();
  String get typeText => type.name.toUpperCase().replaceAll('_', ' ');

  Color get statusColor {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.cancelled:
        return Colors.grey;
    }
  }

  IconData get typeIcon {
    switch (type) {
      case TransactionType.referral:
        return Icons.people;
      case TransactionType.videoEarning:
        return Icons.video_collection;
      case TransactionType.withdrawal:
        return Icons.account_balance_wallet;
      case TransactionType.deposit:
        return Icons.add_circle;
      case TransactionType.bonus:
        return Icons.card_giftcard;
      case TransactionType.penalty:
        return Icons.warning;
      case TransactionType.refund:
        return Icons.undo;
    }
  }

  factory Transaction.mock(int index) {
    final types = TransactionType.values;
    final statuses = TransactionStatus.values;
    final now = DateTime.now();
    
    return Transaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}_$index',
      title: _getMockTitle(types[index % types.length]),
      description: _getMockDescription(types[index % types.length]),
      amount: _getMockAmount(types[index % types.length]),
      type: types[index % types.length],
      status: statuses[index % statuses.length],
      date: now.subtract(Duration(days: index)),
      referenceId: 'REF${1000 + index}',
      notes: index % 3 == 0 ? 'Additional notes for transaction' : null,
    );
  }

  static String _getMockTitle(TransactionType type) {
    switch (type) {
      case TransactionType.referral:
        return 'Referral Bonus';
      case TransactionType.videoEarning:
        return 'Video Earnings';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.bonus:
        return 'Welcome Bonus';
      case TransactionType.penalty:
        return 'Penalty';
      case TransactionType.refund:
        return 'Refund';
    }
  }

  static String _getMockDescription(TransactionType type) {
    switch (type) {
      case TransactionType.referral:
        return 'Earned from successful referral';
      case TransactionType.videoEarning:
        return 'Earnings from video views';
      case TransactionType.withdrawal:
        return 'Withdrawal to bank account';
      case TransactionType.deposit:
        return 'Deposit from bank account';
      case TransactionType.bonus:
        return 'Welcome bonus for new user';
      case TransactionType.penalty:
        return 'Penalty for policy violation';
      case TransactionType.refund:
        return 'Refund for cancelled transaction';
    }
  }

  static double _getMockAmount(TransactionType type) {
    switch (type) {
      case TransactionType.referral:
        return 50.0;
      case TransactionType.videoEarning:
        return 150.0 + (DateTime.now().millisecondsSinceEpoch % 500);
      case TransactionType.withdrawal:
        return -500.0 - (DateTime.now().millisecondsSinceEpoch % 1000);
      case TransactionType.deposit:
        return 1000.0 + (DateTime.now().millisecondsSinceEpoch % 2000);
      case TransactionType.bonus:
        return 100.0;
      case TransactionType.penalty:
        return -25.0;
      case TransactionType.refund:
        return 75.0;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'amount': amount,
    'type': type.name,
    'status': status.name,
    'date': date.toIso8601String(),
    'referenceId': referenceId,
    'notes': notes,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    amount: (json['amount'] as num).toDouble(),
    type: TransactionType.values.firstWhere((e) => e.name == json['type']),
    status: TransactionStatus.values.firstWhere((e) => e.name == json['status']),
    date: DateTime.parse(json['date']),
    referenceId: json['referenceId'],
    notes: json['notes'],
  );
}

class WalletSummary {
  final double balance;
  final double totalEarnings;
  final double totalWithdrawals;
  final double pendingAmount;
  final int totalTransactions;
  final double monthlyEarnings;
  final double weeklyEarnings;
  final double todayEarnings;

  WalletSummary({
    required this.balance,
    required this.totalEarnings,
    required this.totalWithdrawals,
    required this.pendingAmount,
    required this.totalTransactions,
    required this.monthlyEarnings,
    required this.weeklyEarnings,
    required this.todayEarnings,
  });

  factory WalletSummary.mock() => WalletSummary(
    balance: 12550.75,
    totalEarnings: 25000.00,
    totalWithdrawals: 12450.25,
    pendingAmount: 500.00,
    totalTransactions: 156,
    monthlyEarnings: 3500.00,
    weeklyEarnings: 875.50,
    todayEarnings: 125.25,
  );

  Map<String, dynamic> toJson() => {
    'balance': balance,
    'totalEarnings': totalEarnings,
    'totalWithdrawals': totalWithdrawals,
    'pendingAmount': pendingAmount,
    'totalTransactions': totalTransactions,
    'monthlyEarnings': monthlyEarnings,
    'weeklyEarnings': weeklyEarnings,
    'todayEarnings': todayEarnings,
  };

  factory WalletSummary.fromJson(Map<String, dynamic> json) => WalletSummary(
    balance: (json['balance'] as num).toDouble(),
    totalEarnings: (json['totalEarnings'] as num).toDouble(),
    totalWithdrawals: (json['totalWithdrawals'] as num).toDouble(),
    pendingAmount: (json['pendingAmount'] as num).toDouble(),
    totalTransactions: json['totalTransactions'],
    monthlyEarnings: (json['monthlyEarnings'] as num).toDouble(),
    weeklyEarnings: (json['weeklyEarnings'] as num).toDouble(),
    todayEarnings: (json['todayEarnings'] as num).toDouble(),
  );
}

class EarningStats {
  final double totalEarnings;
  final double videoEarnings;
  final double referralEarnings;
  final double bonusEarnings;
  final double monthlyEarnings;
  final double weeklyEarnings;
  final double todayEarnings;
  final int totalVideos;
  final int totalReferrals;
  final double averageEarningPerVideo;
  final double averageEarningPerReferral;

  EarningStats({
    required this.totalEarnings,
    required this.videoEarnings,
    required this.referralEarnings,
    required this.bonusEarnings,
    required this.monthlyEarnings,
    required this.weeklyEarnings,
    required this.todayEarnings,
    required this.totalVideos,
    required this.totalReferrals,
    required this.averageEarningPerVideo,
    required this.averageEarningPerReferral,
  });

  factory EarningStats.mock() => EarningStats(
    totalEarnings: 25000.00,
    videoEarnings: 18000.00,
    referralEarnings: 5000.00,
    bonusEarnings: 2000.00,
    monthlyEarnings: 3500.00,
    weeklyEarnings: 875.50,
    todayEarnings: 125.25,
    totalVideos: 45,
    totalReferrals: 100,
    averageEarningPerVideo: 400.00,
    averageEarningPerReferral: 50.00,
  );
}
