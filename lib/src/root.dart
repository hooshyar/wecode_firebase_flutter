import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wecode_firebase_flutter/src/screens/crud_operation_screen.dart';
import 'package:wecode_firebase_flutter/src/screens/login_screen_view.dart';
import 'package:wecode_firebase_flutter/src/screens/upload_image_screen_view.dart';

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark)),
      home: UploadImageScreen(),
    );
  }
}
