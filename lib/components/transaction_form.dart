import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TransactionForm extends StatefulWidget {
  final void Function(String, String, double, DateTime, String, File?) onSubmit;

  const TransactionForm(this.onSubmit, {super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _url = 'https://goodhelper-59c18-default-rtdb.firebaseio.com/list.json';
  final _nameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _situationController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  File? _selectedImage;
  final _phoneNumberFormatter = MaskTextInputFormatter(mask: '(##) #####-####');

  void _submitForm() async {
    final name = _nameController.text;
    final phone = _phoneNumberFormatter.getMaskedText();
    final situation = _situationController.text;
    final dateTime = _selectedDate?.toIso8601String();

    if (name.isEmpty || phone.isEmpty || _selectedDate == null) {
      return;
    }

    String? imageBase64;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    final future = http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          "name": name,
          "phone": phone,
          "situation": situation,
          "dateTime": dateTime,
          "img": imageBase64,
        },
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    future.then(
      (response) {
        final id = jsonDecode(response.body)['name'];
        widget.onSubmit(
            id,
            name,
            double.tryParse(phone.replaceAll(RegExp(r'\D'), '')) ?? 0,
            _selectedDate!,
            situation,
            _selectedImage);
      },
    );
  }

  Future<void> loadList() async {
    final response = await http.get(
      Uri.parse(_url),
    );
    print(jsonDecode(response.body));
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
          bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              TextField(
                controller: _phonenumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneNumberFormatter],
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                ),
              ),
              TextField(
                controller: _situationController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  labelText: 'Situação',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedImage == null
                          ? 'Nenhuma imagem selecionada!'
                          : 'Imagem Selecionada!',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text(
                      'Selecionar Imagem',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Nenhuma data selecionada!'
                            : 'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _showDatePicker,
                      child: const Text(
                        'Selecionar Data',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Nova Transação',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}