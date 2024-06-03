import 'baseNetwork.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadEvents() {
    return BaseNetwork.get("get-events?show=15");
  }

  Future<Map<String, dynamic>> loadDetailEvents(String slugDiterima) {
    String slug = slugDiterima.toString();
    return BaseNetwork.get("v2/public/detail/$slug");
  }

  Future<Map<String, dynamic>> loadSearchEvents(String cariDiterima) {
    String cari = cariDiterima.toString();
    return BaseNetwork.get("search/$cari");
  }
}
