import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import '../utils/app.routes.dart';
import 'package:http/http.dart' as http;

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  const TransactionList(this.transactions, this.onRemove, {super.key});

  void _detailsScreen(BuildContext context, Transaction transaction) {
    Navigator.of(context).pushNamed(
      AppRoutes.DETAIL,
      arguments: transaction,
    );
  }

Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://goodhelper-59c18-default-rtdb.firebaseio.com/HelpList.json'));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['title'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Nenhuma emergência cadastrada!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: Image.asset(
                      'asset/images/Help.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Precisando de ajuda? Cadastre aqui',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return InkWell(
                onTap: () => _detailsScreen(context, tr),
                splashColor: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blueAccent,
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: tr.image != null
                              ? Image.file(
                                  tr.image!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                        Text(
                          'Nome: ${tr.name}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Número de Contato: ${_formatPhoneNumber(tr.phone.toStringAsFixed(0))}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 10,
                          thickness: 2,
                        ),
                        Text(
                          'Situação: ${tr.situation}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      DateFormat('d MMM y').format(tr.date),
                    ),
                  ),
                ),
              );
            },
          );
  }

  String _formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAllMapped(
      RegExp(r'(\d{2})(\d{5})(\d{4})'),
      (Match m) => '(${m[1]}) ${m[2]}-${m[3]}',
    );
  }
}
