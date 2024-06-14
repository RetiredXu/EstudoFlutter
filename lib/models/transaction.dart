import 'dart:io';
import 'dart:typed_data';

class Transaction {
  final String id;
  final String name;
  final String phone;
  final DateTime date;
  final String situation;
  final File? image;

  Transaction({
    required this.id,
    required this.name,
    required this.phone,
    required this.date,
    required this.situation,
    this.image,
  });
}
