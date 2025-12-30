import 'package:flutter/material.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PaymentHistory> history = [
      PaymentHistory(
        orderId: "#ORD-78452",
        amount: 85,
        date: "30 Dec, 4:15 PM",
        isCredit: true,
      ),
      PaymentHistory(
        orderId: "#ORD-78421",
        amount: 120,
        date: "30 Dec, 2:10 PM",
        isCredit: true,
      ),
      PaymentHistory(
        orderId: "#ORD-78311",
        amount: 60,
        date: "29 Dec, 9:30 PM",
        isCredit: false,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// BALANCE CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff00A884), Color(0xff00906F)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "AVAILABLE BALANCE",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 6),
                Text(
                  "₹1,245.00",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Updated just now",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// QUICK STATS
          Row(
            children: [
              _StatTile(title: "Orders", value: "12"),
              _StatTile(title: "Tips", value: "₹140"),
              _StatTile(title: "Incentives", value: "₹220"),
            ],
          ),

          const SizedBox(height: 24),

          /// RECENT TRANSACTIONS TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full payment history
                },
                child: const Text("View All"),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// TRANSACTIONS LIST
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = history[index];
              return _PaymentTile(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentHistory item;
  const _PaymentTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: CircleAvatar(
        backgroundColor: item.isCredit
            ? Colors.green.shade100
            : Colors.orange.shade100,
        child: Icon(
          item.isCredit ? Icons.arrow_downward : Icons.schedule,
          color: item.isCredit ? Colors.green : Colors.orange,
        ),
      ),
      title: Text(
        item.orderId,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(item.date),
      trailing: Text(
        "${item.isCredit ? '+' : ''}₹${item.amount}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: item.isCredit ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}

class PaymentHistory {
  final String orderId;
  final int amount;
  final String date;
  final bool isCredit;

  PaymentHistory({
    required this.orderId,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;

  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
