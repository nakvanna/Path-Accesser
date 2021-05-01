import 'package:get/get.dart';
import 'package:path_accesser/pages/controllers/path_accessing_controller.dart';

class PathAccessingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PathAccessingController>(() => PathAccessingController());
  }
}
