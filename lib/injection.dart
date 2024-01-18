import 'package:get_it/get_it.dart';

import 'services/local_db_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton<LocalDB>(LocalDB());
}
