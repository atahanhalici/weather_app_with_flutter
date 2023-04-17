import 'package:location/location.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/api_service.dart';

class Repository {
  final ApiService _databaseService = locator<ApiService>();
  Future<LocationHelper> getCurrentLocation() async {
    Location location = Location();

    //Location için servis ayakta mı?
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LocationHelper(latitude: 0, longitude: 0);
      }
    }

    //konum izni kontrolü
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return LocationHelper(latitude: 0, longitude: 0);
      }
    }

    //izinler tamam ise
    LocationData _locationData = await location.getLocation();
    double latitude = _locationData.latitude!;
    double longitude = _locationData.longitude!;
    return LocationHelper(latitude: latitude, longitude: longitude);
  }

  Future<dynamic> getWeatherKonum(double latitude, double longitude) async {
    Weather hd = await _databaseService.getWeatherKonum(latitude, longitude);
    return hd;
  }

  getWeather(String sehir)async{
    Weather hd = await _databaseService.getWeather(sehir);
    return hd;
  }
}
