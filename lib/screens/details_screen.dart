import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Transaction transaction =
        ModalRoute.of(context)!.settings.arguments as Transaction;

    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.name),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (transaction.image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            transaction.image!,
                            fit: BoxFit.cover,
                            height: 340,
                            width: double.infinity,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Name:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey[600]),
                      ),
                      Text(
                        transaction.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Phone:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey[600]),
                      ),
                      Text(
                        _formatPhoneNumber(transaction.phone),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Date:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey[600]),
                      ),
                      Text(
                        DateFormat('d MMM y').format(transaction.date),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Situation:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey[600]),
                      ),
                      Text(
                        transaction.situation,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    _showDonationDialog(context, transaction.name);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Ajudar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDonationDialog(BuildContext context, String recipientName) {
    final TextEditingController donationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Doação'),
          content: TextField(
            controller: donationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Valor da Doação',
              prefixText: 'R\$ ',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final donationAmount = double.tryParse(donationController.text);
                if (donationAmount != null) {
                  await _sendDonationToFirebase(recipientName, donationAmount);
                  Navigator.of(context).pop(); // Close the dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sucesso'),
                      content: const Text('Doação realizada com sucesso!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the success dialog
                            // Navigator.of(context).pushNamed(
                            //     '/donations'); // Navigate to donations screen
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Doar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendDonationToFirebase(
      String recipientName, double donationAmount) async {
    const url =
        'https://goodhelper-59c18-default-rtdb.firebaseio.com/Donations.json';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'recipientName': recipientName,
          'donationAmount': donationAmount,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final id = jsonDecode(response.body)['name'];
        print('Doação enviada com sucesso! ID: $id');
        // Here you can handle success, maybe update UI or show a success message
      } else {
        throw Exception('Falha ao enviar a doação');
      }
    } catch (e) {
      print('Erro ao enviar doação: $e');
      // Handle error, show error message, etc.
      throw Exception('Falha ao enviar a doação');
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAllMapped(
      RegExp(r'(\d{2})(\d{5})(\d{4})'),
      (Match m) => '(${m[1]}) ${m[2]}-${m[3]}',
    );
  }
}
