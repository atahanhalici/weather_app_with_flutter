import 'package:get_it/get_it.dart';
import 'package:weather_app/repository/repository.dart';
import 'package:weather_app/services/api_service.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => ApiService());
}
