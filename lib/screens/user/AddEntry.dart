import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/entry_provider.dart';
import '../../model/entry_model.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({super.key});

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  final formKey = GlobalKey<FormState>();

  final Map<String, bool> symptomsList = {
    "Fever (37.8 C and above)": false,
    "Feeling feverish": false,
    "Muscle or joint pains": false,
    "Cough": false,
    "Colds": false,
    "Sore throat": false,
    "Difficulty of breathing": false,
    "Diarrhea": false,
    "Loss of taste": false,
    "Loss of smell": false,
  };

  String? inContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Today\'s Entry'),
          centerTitle: true,
          backgroundColor: const Color(0xFF090c12),
        ),
        body: entry());
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
              child: ListView(children: [
                Column(children: [
                  Row(
                    children: [Expanded(child: title())],
                  ),
                  symptoms(),
                  monitoring(),
                  submitButton(),
                  const SizedBox(
                    height: 30,
                  )
                ]),
              ]),
            ),
          ),
        ));
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
            )
          ],
        ));
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
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
              title: Text(symptomsList.keys.elementAt(index)),
              value: symptomsList[symptomsList.keys.elementAt(index)],
              onChanged: (bool? value) {
                setState(() {
                  symptomsList[symptomsList.keys.elementAt(index)] = value!;
                });
              });
        },
        itemCount: symptomsList.length,
      ),
    );
  }

  Widget monitoring() {
    return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 25, left: 40, right: 40),
        padding: const EdgeInsets.all(12),
        height: 90,
        decoration: const BoxDecoration(
          // color: Colors.white,
          color: Color(0xFF222429),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Flexible(
              child: Text(
                  'Did you have a face-to-face encounter or contact with a confirmed COVID-19 case?'),
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
                            inContact = value!;
                          });
                        }),
                    const Text('Yes')
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                            value: 'no',
                            groupValue: inContact,
                            onChanged: (value) {
                              setState(() {
                                inContact = value!;
                              });
                            }),
                        const Text('No')
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ));
  }

  Widget submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final entryProvider = context.read<EntryProvider>();

            if (inContact == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Please select an answer in the last question')));
            } else {
              bool contact;
              DateTime dateToday = DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day)
                  .copyWith(
                      hour: 0,
                      minute: 0,
                      second: 0,
                      millisecond: 0,
                      microsecond: 0,
                      isUtc: true);
              if (inContact == 'yes') {
                contact = true;
              } else {
                contact = false;
              }
              DailyEntry dailyEntry = DailyEntry(
                  uid: context.read<AuthProvider>().currentUser.uid,
                  symptoms: symptomsList,
                  closeContact: contact,
                  entryDate: dateToday);
              User user = context.read<AuthProvider>().currentUser;
              entryProvider.addEntry(dailyEntry, user);
              formKey.currentState?.save();

              Navigator.pop(context);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF526bf2),
        ),
        child: const Text('Submit'));
  }
}
