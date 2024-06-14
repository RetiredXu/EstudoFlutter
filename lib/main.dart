import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goodhelpers/components/transaction_form.dart';
import 'package:goodhelpers/providers/donation_provider.dart';
import 'package:provider/provider.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';
import 'components/main_drawer.dart';
import 'screens/details_screen.dart';
import 'screens/donation_screnn.dart';
import 'utils/app.routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({super.key});
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DonationProvider()),
      ],
      child: MaterialApp(
        home: const MyHomePage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.pink,
            secondary: Colors.amber,
          ),
          scaffoldBackgroundColor: const Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold),
              ),
        ),
        initialRoute: AppRoutes.HOME,
        routes: {
          AppRoutes.DETAIL: (ctx) => const DetailsScreen(),
          AppRoutes.DONATION: (ctx) => const DonationScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;
  late Future<void> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://goodhelper-59c18-default-rtdb.firebaseio.com/HelpList.json'));
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    List<Transaction> loadedTransactions = [];

    for (var key in data.keys) {
      var value = data[key];
      File? imageFile;

      if (value['img'] != null) {
        Uint8List bytes = base64Decode(value['img']);
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String filePath = '$tempPath/${key}_image.jpg';
        await File(filePath).writeAsBytes(bytes);
        imageFile = File(filePath);
      }

      loadedTransactions.add(
        Transaction(
          id: key,
          name: value['name'],
          phone: value['phone'],
          date: DateTime.parse(value['dateTime']),
          situation: value['situation'],
          image: imageFile,
        ),
      );
      print(imageFile);
    }

    setState(() {
      _transactions.addAll(loadedTransactions);
    });
  }

  _addTransaction(String id, String name, String phone, DateTime date,
      String situation, File? image) {
    final newTransaction = Transaction(
      id: id,
      name: name,
      phone: phone,
      date: date,
      situation: situation,
      image: image,
    );

    setState(
      () {
        _transactions.add(newTransaction);
      },
    );

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(
      () {
        _transactions.removeWhere((tr) => tr.id == id);
      },
    );
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text('Good Helper'),
      actions: [
        if (isLandscape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.show_chart),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight,
                child: FutureBuilder<void>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return TransactionList(_transactions, _removeTransaction);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
