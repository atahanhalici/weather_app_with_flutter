
class LocationHelper {
  double latitude;
  double longitude;

  LocationHelper({
    required this.latitude,
    required this.longitude,
  });
  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  LocationHelper.fromMap(Map<String, dynamic> map)
      : latitude = map["latitude"],
        longitude = map["longitude"];

  @override
  String toString() {
    return "Mesaj {latitude: $latitude, longitude: $longitude}";
  }

 
}
