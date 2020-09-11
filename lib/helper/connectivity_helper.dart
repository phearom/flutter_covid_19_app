import 'package:connectivity/connectivity.dart';

class ConnectivityHelper {
  static Future<ConnectivityType> updateConnectivityStatus(ConnectivityResult result) async {
    //var connectivityResult = await (Connectivity().checkConnectivity());
    ConnectivityType _connectionType = ConnectivityType.Unknown;
    if (result == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
      _connectionType = ConnectivityType.Connected;
    } else if (result == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      _connectionType = ConnectivityType.Connected;
    } else if (result == ConnectivityResult.none) {
      print("Unable to connect. Please Check Internet Connection");
      _connectionType = ConnectivityType.NotConnected;
    } else {
      print("Unable to connect. Please Check Internet Connection, first load");
      _connectionType = ConnectivityType.Unknown;
    }
    return _connectionType;
  }

  static ConnectivityType getConnectivityType(ConnectivityResult result) {
    ConnectivityType _connType = ConnectivityType.Unknown;
    switch (result) {
      case ConnectivityResult.mobile:
        _connType = ConnectivityType.Connected;
        break;
      case ConnectivityResult.wifi:
        _connType = ConnectivityType.Connected;
        break;
      case ConnectivityResult.none:
        _connType = ConnectivityType.NotConnected;
        break;
      default:
        _connType = ConnectivityType.Unknown;
        break;
    }
    return _connType;
  }
}

enum ConnectivityType { Connected, NotConnected, Unknown }
