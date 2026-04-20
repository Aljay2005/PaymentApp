import 'package:flutter/material.dart';

/// Shows payment confirmation after Stripe returns success.
class SuccessPage extends StatelessWidget {
  final double amount;
  final String transactionId;

  const SuccessPage({super.key, required this.amount, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 100),
              const SizedBox(height: 24),
              const Text('Payment Successful!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Transaction details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _row('Amount', '₱${amount.toStringAsFixed(2)}'),
                      const Divider(),
                      _row('Transaction ID', transactionId),
                      const Divider(),
                      _row('Currency', 'PHP (Philippine Peso)'),
                      const Divider(),
                      _row('Status', 'Succeeded ✓'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⚡ Stripe Sandbox — no real charge',
                  style: TextStyle(fontSize: 11, color: Colors.orange),
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back to Shop'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          Flexible(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}