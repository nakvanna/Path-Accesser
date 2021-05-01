import 'package:get/get.dart';
import 'package:path_accesser/pages/bindings/path_accessing_binding.dart';
import 'package:path_accesser/pages/home/home_page.dart';
import 'package:path_accesser/pages/path-accessing/path_accessing_ui.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(title: 'Path Accessing'),
    ),
    GetPage(
      name: _Paths.SUB_PATH_UI,
      page: () => PathAccessingUI(),
      binding: PathAccessingBinding(),
    ),
  ];
}
