import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
saveLocalData(key,value)async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

getLocalData(key)async{
  final String? action;
  final prefs = await SharedPreferences.getInstance();

   action = prefs.getString(key);
   return action;

}


 removeUser()async{
   final prefs = await SharedPreferences.getInstance();
   prefs.clear();
 }
}