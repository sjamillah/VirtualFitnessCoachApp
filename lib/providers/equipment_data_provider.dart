import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EquipmentDataProvider with ChangeNotifier {
  List<String> basicGymEquipment = [];
  List<String> fullGymEquipment = [];

  Future<void> loadEquipmentData() async {
    final String response = await rootBundle.loadString('assets/equipment_data.json');
    final data = await json.decode(response);

    basicGymEquipment = List<String>.from(data['basicGymEquipment']);
    fullGymEquipment = List<String>.from(data['fullGymEquipment']);

    notifyListeners();
  }
}