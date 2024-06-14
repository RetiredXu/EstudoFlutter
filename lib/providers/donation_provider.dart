import 'package:flutter/material.dart';
import '../models/donation.dart';

class DonationProvider with ChangeNotifier {
  List<Donation> _donations = [];

  List<Donation> get donations => _donations;

  void addDonation(Donation donation) {
    _donations.add(donation);
    notifyListeners();
  }

  void setDonations(List<Donation> list) {}
}
