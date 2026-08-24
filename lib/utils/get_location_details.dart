
import 'package:geocoding/geocoding.dart' ;
import 'package:location/location.dart'as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';


/*void  getLocationPermission() async {


  if(await Permission.location.isGranted)
    {
      ALL_Name_ID all_name_id = await getLocationandAddress();

      return all_name_id;
    }
  else
    {
      Permission.location.request();
    }
}*/

Future<ALL_Name_ID> getLocationandAddress() async {

  loc.LocationData locationData = await  loc.Location.instance.getLocation();




       List<Placemark> placemark = [];
       placemark = await placemarkFromCoordinates(locationData.latitude,locationData.longitude);


       ALL_Name_ID all_name_id = ALL_Name_ID();
       all_name_id.Latitude = locationData.latitude.toString();
       all_name_id.Longitude = locationData.longitude.toString();
       all_name_id.Name = "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";
           //placemark[0].name.toString() + placemark[0].street.toString() + ","+ placemark[0].locality.toString() +","+placemark[0].country.toString();


  for(int i=0;i<placemark.length;i++)
       {
            print("slffds" + "${placemark[i].name}, ${placemark[i].street}, ${placemark[i].subLocality}, ${placemark[i].locality}, ${placemark[i].administrativeArea}, ${placemark[i].country},");

       }

       return all_name_id;


}