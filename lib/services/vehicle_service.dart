import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/models/vehicle.dart';
import 'package:taxi_segurito_app/services/server.dart';
import 'package:taxi_segurito_app/models/owner.dart';

Future<bool> update(Vehicle vehicle) async {
  try {
    var path = Server.url + "vehicle_controller.php";
    final response = await http.post(
      Uri.parse(path),
      body: jsonEncode(
        {
          "idVehicle": vehicle.idVehicle,
          "color": vehicle.color,
          "model": vehicle.model,
          "pleik": vehicle.pleik,
          "capacity": vehicle.capacity,
          "photo": vehicle.picture,
          "status": vehicle.status,
          "owner_idowner": vehicle.idOwner,
          "typeRequest": "UPDATE"
        },
      ),
    );
    String result = json.decode(response.body);

    if (result == "Success") {
      return true;
    } else {
      return Future<bool>.value(false);
    }
  } catch (exception) {
    return Future<bool>.value(false);
  }
}
