import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/donation_provider.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final donations = Provider.of<DonationProvider>(context).donations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Doações'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: donations.isEmpty
            ? const Center(
                child: Text(
                  'Você ainda não fez nenhuma doação.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final donation = donations[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(donation.recipientName),
                      subtitle: Text(
                          'Valor doado para ${donation.recipientName}: R\$ ${donation.amount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
