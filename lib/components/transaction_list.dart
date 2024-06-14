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

  void _deleteTransaction(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
            'Tem certeza que deseja excluir a transação ${transaction.name}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o AlertDialog
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Fechar o AlertDialog

              try {
                onRemove(transaction.id);

                // Mostrar um AlertDialog para indicar sucesso
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Transação Removida'),
                    content: Text(
                        'Transação ${transaction.name} removida com sucesso.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Fechar o AlertDialog
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              } catch (error) {
                // Mostrar um AlertDialog para indicar erro
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Erro ao Remover Transação'),
                    content: Text('Erro ao remover transação: $error'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Fechar o AlertDialog
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
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
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTransaction(context, tr),
                          color: Theme.of(context).errorColor,
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
