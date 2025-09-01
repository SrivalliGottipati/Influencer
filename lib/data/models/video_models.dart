// class VideoLinkRequest {
//   VideoLinkRequest({required this.url});
//   final String url;
//   Map<String, dynamic> toJson() => {'url': url};
// }
//
// class VideoSummary {
//   VideoSummary({required this.total, required this.views, required this.earnings});
//   final int total;
//   final int views;
//   final double earnings;
//   factory VideoSummary.mock() => VideoSummary(total: 24, views: 58200, earnings: 12500);
// }


// package:influencer/data/models/video_models.dart

class VideoLinkRequest {
  VideoLinkRequest({required this.url});
  final String url;
  Map<String, dynamic> toJson() => {'url': url};
}

class VideoSummary {
  VideoSummary({required this.total, required this.views, required this.earnings});

  final int total;
  final int views;
  final double earnings;

  // Keep mock so UI can run with Env.useMocks
  factory VideoSummary.mock() => VideoSummary(total: 24, views: 58200, earnings: 12500);
}

/// Minimal transaction model in same file to avoid cross-file type mismatch.
/// You can move it later, but ensure imports remain consistent.
class TransactionModel {
  TransactionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });

  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final bool isCredit;

  factory TransactionModel.mock(int i) => TransactionModel(
    id: 'tx_$i',
    title: i % 2 == 0 ? 'Referral bonus' : 'Upload payout',
    date: DateTime.now().subtract(Duration(days: i)),
    amount: (i + 1) * 50.0,
    isCredit: i % 2 == 0,
  );

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json['id'] as String,
    title: json['title'] as String,
    date: DateTime.parse(json['date'] as String),
    amount: (json['amount'] as num).toDouble(),
    isCredit: json['isCredit'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date.toIso8601String(),
    'amount': amount,
    'isCredit': isCredit,
  };
}
