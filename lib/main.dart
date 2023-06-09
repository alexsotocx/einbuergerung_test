import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppBuilder().build(RepositoryType.memory).then((app) => runApp(app));
}
