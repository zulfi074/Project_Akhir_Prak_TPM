import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<void> savePref(
      int value, String nama, String email, String image) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("value", value);
    await preferences.setString("nama", nama);
    await preferences.setString("email", email);
    await preferences.setString("image", image);
  }

  static Future<Map<String, dynamic>> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? value = preferences.getInt("value");
    String? nama = preferences.getString("nama");
    String? email = preferences.getString("email");
    String? image = preferences.getString("image");

    return {
      'value': value,
      'nama': nama,
      'email': email,
      'image': image,
    };
  }

  static Future<void> signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("value");
    await preferences.remove("nama");
    await preferences.remove("email");
    await preferences.remove("image");
  }
}
