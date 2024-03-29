import 'package:flutter_dotenv/flutter_dotenv.dart';

setupdotenv() async {
  if (dotenv.isInitialized) {
    await dotenv.load(fileName: ".env");
  }
}

String getIP() {
  //setupdotenv();
  if (dotenv.env['BILLIP']?.isNotEmpty == true) {
    return ('http://' + dotenv.env['BILLIP'].toString() + ':8080');
  } else if (dotenv.env['IP_AREA']?.isNotEmpty == true) {
    return ('http://' + dotenv.env['IP_AREA'].toString() + ':8080');
  }
  return "http://10.0.2.2:8080";
}

