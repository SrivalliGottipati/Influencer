// import 'package:flutter/material.dart';
//
// class InfoCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   const InfoCard({super.key, required this.title, required this.value, required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]),
//       child: Row(children: [Icon(icon, size: 32), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))])]),
//     );
//   }
// }


// package:influencer/core/widgets/info_card.dart

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
