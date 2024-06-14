import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/donation_provider.dart';
import '../models/donation.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  Future<List<Donation>> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://goodhelper-59c18-default-rtdb.firebaseio.com/Donations.json'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data.isEmpty) {
        print('Não há dados disponíveis');
        return []; // Retorna uma lista vazia se não houver dados
      }
      List<Donation> loadedDonations = [];

      data.forEach((key, value) {
        loadedDonations.add(
          Donation(
            id: key,
            name: value['recipientName'],
            amount: value['donationAmount'],
          ),
        );
      });

      return loadedDonations;
    } else {
      throw Exception('Failed to load donations: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Doações'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Donation>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Você ainda não fez nenhuma doação.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              donationProvider.setDonations(snapshot.data!);
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final donation = snapshot.data![index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(donation.name),
                      subtitle: Text(
                          'Valor doado para ${donation.name}: R\$ ${donation.amount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
