import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/entry_provider.dart';
import '../../model/entry_model.dart';

class EditEntry extends StatefulWidget {
  const EditEntry({Key? key}) : super(key: key);

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _remarkController = TextEditingController();

  List<String> symptomsListKeys = [
    "Fever (37.8 C and above)",
    "Feeling feverish",
    "Muscle or joint pains",
    "Cough",
    "Colds",
    "Sore throat",
    "Difficulty of breathing",
    "Diarrhea",
    "Loss of taste",
    "Loss of smell"
  ];

  Map<String, bool> symptomsList = {};

  String? inContact;
  DailyEntry? dailyEntry;

  @override
  void initState() {
    super.initState();
    DateTime timeToday = DateTime.now();
    timeToday = DateTime(timeToday.year, timeToday.month, timeToday.day);
    User user = context.read<AuthProvider>().currentUser;
    StreamSubscription<QuerySnapshot> subscription = FirebaseFirestore.instance
        .collection("entry")
        .where('uid', isEqualTo: user.uid)
        .where('entryDate', isGreaterThanOrEqualTo: timeToday)
        .where('entryDate', isLessThan: timeToday.add(const Duration(days: 1)))
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = snapshot.docs[0];
        Map<String, dynamic> entryData =
            document.data() as Map<String, dynamic>;
        // Use the entryData map as needed
        DailyEntry entry = DailyEntry.fromJson(entryData, 'fetch');
        setState(() {
          dailyEntry = entry;
          for (String key in symptomsListKeys) {
            symptomsList[key] = dailyEntry!.symptoms[key]!;
          }
          if (dailyEntry?.closeContact == true) {
            inContact = 'yes';
          } else {
            inContact = 'no';
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Today\'s Entry'),
        centerTitle: true,
        backgroundColor: const Color(0xFF090c12),
      ),
      body: entry(),
    );
  }

  Widget entry() {
    return Scaffold(
      backgroundColor: const Color(0xFF090c12),
      body: Center(
        child: Container(
          width: 500,
          color: const Color(0xFF090c12),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: title()),
                      ],
                    ),
                    symptoms(),
                    monitoring(),
                    remarks(),
                    submitButton(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 40, right: 40),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF222429),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Are you experiencing any of these symptoms? ",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Select all that apply.'),
          ),
        ],
      ),
    );
  }

  Widget symptoms() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 40, right: 40),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF222429),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: symptomsList.length,
        itemBuilder: (BuildContext context, int index) {
          String symptom = symptomsList.keys.elementAt(index);
          return CheckboxListTile(
            title: Text(symptom),
            value: symptomsList[symptom],
            onChanged: (bool? value) {
              setState(() {
                symptomsList[symptom] = value!;
              });
            },
          );
        },
      ),
    );
  }

  Widget monitoring() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 25, left: 40, right: 40),
      padding: const EdgeInsets.all(12),
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFF222429),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Flexible(
            child: Text(
              'Did you have a face-to-face encounter or contact with a confirmed COVID-19 case?',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio(
                    value: 'yes',
                    groupValue: inContact,
                    onChanged: (value) {
                      setState(() {
                        inContact = value;
                        dailyEntry!.closeContact = true;
                      });
                    },
                  ),
                  const Text('Yes'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 'no',
                    groupValue: inContact,
                    onChanged: (value) {
                      setState(() {
                        inContact = value;
                        dailyEntry!.closeContact = false;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget remarks() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, left: 40, right: 40),
      padding: const EdgeInsets.all(12),
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFF222429),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextFormField(
          controller: _remarkController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a remark';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Reason for editing entry',
          ),
          onChanged: (String value) {
            dailyEntry!.remarks = value;
          }),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          final entryProvider = context.read<EntryProvider>();

          if (inContact == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please select an answer in the last question')));
          } else {
            dailyEntry!.symptoms = symptomsList;
            print(dailyEntry!.symptoms);
            entryProvider.editEntryRequest(dailyEntry!.entryId!, dailyEntry!);

            // formKey.currentState?.save();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Successfully requested for editing entry!')));
            Navigator.pop(context);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF526bf2),
      ),
      child: const Text('Submit'),
    );
  }
}
