import 'package:geolocator/geolocator.dart';

class LocationRepository {


  Future<Position> getUserLocation() async {
    
      try {
      Position userLocation =  await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
            return userLocation;
      } catch (error) {
        print('Error getting user location: $error');
        rethrow;
      }
    }
  
}
