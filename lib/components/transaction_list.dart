import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  const TransactionList(this.transactions, this.onRemove, {super.key});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Nenhuma emergência Cadastrada!',
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
                  'Precisando de ajuda? cadastre aqui',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return Card(
                color: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: tr.image != null
                      ? SizedBox(
                          width: 65,
                          height: 65,
                          child: Image.file(
                            tr.image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox(
                          width: 65,
                          height: 65,
                          child: Icon(Icons.image_not_supported),
                        ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
