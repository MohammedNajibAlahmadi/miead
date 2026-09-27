import 'package:flutter/material.dart';
import 'package:miead/app/app.dart';
import 'package:miead/app/dependency_injection/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await setupDependencies();
  
  runApp(const MieadApp());
}

// TODO: Implement Issue #1 as team Mohammed and Ali
