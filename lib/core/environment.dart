import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environtment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env';
    } else {
      return '.env.development';
    }
  }

  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'API_URL not found!';
  }
}
