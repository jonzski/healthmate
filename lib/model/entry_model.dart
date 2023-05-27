import 'dart:convert';

class DailyEntry {
  String uid;
  Map<String, bool> symptoms;
  bool closeContact;
  late String? remarks;
  late String? status;
  late String? entryId;
  late String? entryRequestId;
  late DateTime? requestDate;
  DateTime entryDate;
  late bool canGenerateQR;

  DailyEntry({
    required this.uid,
    required this.symptoms,
    required this.closeContact,
    required this.entryDate,
    this.remarks,
    this.status,
    this.entryId,
    this.requestDate,
  }) {
    this.canGenerateQR =
        !(this.closeContact || this.symptoms.containsValue(true));
  }

  factory DailyEntry.fromJson(Map<String, dynamic> json) {
    dynamic linkedMap = json['symptoms'];

    Map<String, bool> convertedMap = {};
    linkedMap.forEach((key, value) {
      if (value is bool) {
        convertedMap[key] = value;
      }
    });

    return DailyEntry(
      uid: json['uid'],
      symptoms: convertedMap,
      closeContact: json['closeContact'],
      entryDate: json['entryDate'].toDate(),
      remarks: json['remarks'],
      status: json['status'],
      entryId: json['entryId'],
      requestDate: json['requestDate'],
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
      'remarks': entry.remarks,
      'status': entry.status,
      'entryId': entry.entryId,
      'requestDate': entry.requestDate,
    };
  }
}
