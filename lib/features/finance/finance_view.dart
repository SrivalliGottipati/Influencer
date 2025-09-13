import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/services/notification_service.dart';
import 'package:influencer/data/models/finance_models.dart';
import 'finance_controller.dart';

class FinanceView extends GetView<FinanceController> {
  const FinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;
    
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.summary.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(resp.spacing(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, resp),
                SizedBox(height: resp.spacing(20)),
                _buildBalanceCard(context, resp),
                SizedBox(height: resp.spacing(20)),
                _buildQuickActions(context, resp),
                SizedBox(height: resp.spacing(20)),
                _buildEarningsOverview(context, resp),
                SizedBox(height: resp.spacing(20)),
                _buildReferralSection(context, resp),
                SizedBox(height: resp.spacing(20)),
                _buildTransactionsHeader(context, resp),
                SizedBox(height: resp.spacing(12)),
                _buildTransactionsList(context, resp),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, Responsive resp) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Finance',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: resp.spacing(4)),
              Text(
                'Manage your earnings and transactions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: controller.refreshData,
          icon: const Icon(Icons.refresh),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            foregroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, Responsive resp) {
    final summary = controller.summary.value;
    if (summary == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(resp.spacing(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
              SizedBox(width: resp.spacing(8)),
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: resp.spacing(12)),
          Text(
            '₹${summary.balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: resp.spacing(16)),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  context,
                  'Pending',
                  '₹${summary.pendingAmount.toStringAsFixed(2)}',
                  Icons.schedule,
                ),
              ),
              SizedBox(width: resp.spacing(16)),
              Expanded(
                child: _buildBalanceItem(
                  context,
                  'Transactions',
                  '${summary.totalTransactions}',
                  Icons.receipt_long,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(12)),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Withdraw',
                Icons.account_balance_wallet,
                AppColors.primary,
                () => _showWithdrawDialog(context),
              ),
            ),
            SizedBox(width: resp.spacing(12)),
            Expanded(
              child: _buildActionButton(
                context,
                'Deposit',
                Icons.add_circle,
                AppColors.secondary,
                () => _showDepositDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsOverview(BuildContext context, Responsive resp) {
    final stats = controller.earningStats.value;
    if (stats == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Earnings Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(12)),
        Row(
          children: [
            Expanded(
              child: _buildEarningCard(
                context,
                'Today',
                '₹${stats.todayEarnings.toStringAsFixed(2)}',
                Icons.today,
                AppColors.success,
              ),
            ),
            SizedBox(width: resp.spacing(12)),
            Expanded(
              child: _buildEarningCard(
                context,
                'This Week',
                '₹${stats.weeklyEarnings.toStringAsFixed(2)}',
                Icons.date_range,
                AppColors.accent,
              ),
            ),
          ],
        ),
        SizedBox(height: resp.spacing(12)),
        Row(
          children: [
            Expanded(
              child: _buildEarningCard(
                context,
                'This Month',
                '₹${stats.monthlyEarnings.toStringAsFixed(2)}',
                Icons.calendar_month,
                AppColors.primary,
              ),
            ),
            SizedBox(width: resp.spacing(12)),
            Expanded(
              child: _buildEarningCard(
                context,
                'Total',
                '₹${stats.totalEarnings.toStringAsFixed(2)}',
                Icons.trending_up,
                AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context, Responsive resp) {
    return Row(
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            // Navigate to full transactions list
          },
          child: const Text('View All'),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(BuildContext context, Responsive resp) {
    final transactions = controller.filteredTransactions.take(5).toList();
    
    if (transactions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(resp.spacing(32)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.receipt_long, size: 48, color: AppColors.muted),
            SizedBox(height: resp.spacing(12)),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.muted,
              ),
            ),
            SizedBox(height: resp.spacing(4)),
            Text(
              'Your transactions will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: transactions.map((transaction) => _buildTransactionItem(context, transaction)).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: transaction.typeColor?.withOpacity(0.1) ?? AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          transaction.typeIcon,
          color: transaction.typeColor ?? AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        transaction.title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        transaction.description,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.muted,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            transaction.formattedAmount,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: transaction.isCredit ? AppColors.success : AppColors.danger,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            transaction.statusText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: transaction.statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                controller.withdrawFunds(amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    // Implement deposit dialog
    NotificationService.showInfo('Coming Soon', 'Deposit feature will be available soon');
  }

  Widget _buildReferralSection(BuildContext context, Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral Program',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(12)),
        Container(
          padding: EdgeInsets.all(resp.spacing(16)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.secondaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.people, color: Colors.white, size: 24),
                  SizedBox(width: resp.spacing(8)),
                  Text(
                    'Invite Friends & Earn ₹50',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: resp.spacing(12)),
              Text(
                'Share your referral link and earn ₹50 for every successful referral!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: resp.spacing(16)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: resp.spacing(12),
                        vertical: resp.spacing(8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'https://infly.app/invite/ABC123',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: resp.spacing(8)),
                  IconButton(
                    onPressed: () {
                      // Share referral link
                      NotificationService.showInfo('Shared!', 'Referral link shared successfully');
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
