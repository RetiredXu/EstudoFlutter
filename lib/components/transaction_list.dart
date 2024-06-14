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
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: InkWell(
                  onTap: () => _detailsScreen(context, tr),
                  splashColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: tr.image != null
                              ? Image.file(
                                  tr.image!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported, size: 40),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Contato: ${_formatPhoneNumber(tr.phone)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(color: Colors.grey),
                              Text(
                                'Situação: ${tr.situation}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(tr.date),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
