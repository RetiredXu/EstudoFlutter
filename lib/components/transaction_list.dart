import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/transaction_form.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList(this.transactions, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 685,
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tr = transactions[index];
          return Column(
            children: <Widget>[
              Card(
                  elevation: 10,
                  shadowColor:const Color(0xFF2CB8B2), 
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 145,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                        border: Border.all(
                          color: const Color(0xFF2CB8B2),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tr.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('d MMM y').format(tr.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider( // Adicionando a linha de divisão
                color: Colors.black,
                height: 13,
                thickness: 2,
                indent: 10,
                endIndent: 10, 
              ),
            ],
          );
        },
      ),
    );
  }
}
