import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(context.responsive.spacing(16)),
        child: Obx(() {
          final s = controller.summary.value;
          if (s == null) return const Center(child: CircularProgressIndicator());
          return Column(children: [
            Card(child: ListTile(title: const Text('Balance'), trailing: Text('₹${s.balance.toStringAsFixed(0)}'))),
            SizedBox(height: context.responsive.spacing(12)),
            const Text('Transactions'),
            SizedBox(height: context.responsive.spacing(8)),
            Expanded(child: ListView.separated(itemBuilder: (_, i) {
              final t = controller.txns[i];
              final sign = t.amount >= 0 ? '+' : '-';
              return ListTile(leading: Icon(t.amount >= 0 ? Icons.add : Icons.remove), title: Text(t.title), subtitle: Text(t.date), trailing: Text('$sign₹${t.amount.abs()}'));
            }, separatorBuilder: (_, __) => const Divider(), itemCount: controller.txns.length))
          ]);
        }),
      ),
    );
  }
}
