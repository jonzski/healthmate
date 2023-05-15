import 'package:flutter/material.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({super.key});

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
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
        drawer: Drawer(
          backgroundColor: Colors.teal.shade100,
          child: ListView(
            children: [
              ListTile(
                title: const Text(
                  'Homepage',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/UserDashboard'); // close the drawer
                },
              ),
              ListTile(
                title: const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context); // close the drawer
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Add Today\'s Entry'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: entry());
  }

  Widget entry() {
    return Scaffold(
        backgroundColor: Colors.teal.shade50,
        body: ListView(children: [
          Column(
            children: [
              Row(
                children: [Expanded(child: title())],
              ),
              symptoms(),
              monitoring(),
              submitButton(),
            ],
          ),
        ]));
  }

  Widget title() {
    return Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
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
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
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
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.all(12),
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
          Navigator.pushNamed(context, '/UserDashboard');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: const Text('Submit'));
  }
}
