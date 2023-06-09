import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppBuilder().build(RepositoryType.sql).then((app) => runApp(app));
}
