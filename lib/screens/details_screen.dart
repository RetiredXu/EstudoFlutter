import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Transaction transaction = ModalRoute.of(context)!.settings.arguments as Transaction;

    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (transaction.image != null)
              Image.file(
                transaction.image!,
                fit: BoxFit.cover,
                height: 200,
              ),
            Text(
              'Name: ${transaction.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Phone: ${_formatPhoneNumber(transaction.phone.toStringAsFixed(0))}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Date: ${DateFormat('d MMM y').format(transaction.date)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Situation: ${transaction.situation}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  String _formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAllMapped(
      RegExp(r'(\d{2})(\d{5})(\d{4})'),
      (Match m) => '(${m[1]}) ${m[2]}-${m[3]}',
    );
  }
}
