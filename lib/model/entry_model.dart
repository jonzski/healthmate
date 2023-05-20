import 'dart:convert';

class DailyEntry {
  String uid;
  Map<String, bool> symptoms;
  bool closeContact;
  DateTime entryDate;
  late bool canGenerateQR;

  DailyEntry({
    required this.uid,
    required this.symptoms,
    required this.closeContact,
    required this.entryDate,
  }) {
    this.canGenerateQR =
        !(this.closeContact || this.symptoms.containsValue(true));
  }

  factory DailyEntry.fromJson(Map<String, dynamic> json) {
    return DailyEntry(
      uid: json['uid'],
      symptoms: json['symptoms'],
      closeContact: json['closeContact'],
      entryDate: json['entryDate'],
    );
  }

  static List<DailyEntry> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<DailyEntry>((dynamic d) => DailyEntry.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(DailyEntry entry) {
    return {
      'uid': entry.uid,
      'symptoms': entry.symptoms,
      'closeContact': entry.closeContact,
      'entryDate': entry.entryDate,
    };
  }
}
