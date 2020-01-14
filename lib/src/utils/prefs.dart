import 'package:shared_preferences/shared_preferences.dart';

Future<void> persistUserName(String userName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userName', userName);
}

Future<String> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userName') ?? '';
}

Future<void> removeUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userName');
}