// lib/ui/screens/main/controller/main_controller.dart
import 'package:get/get.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;

  void onTabTapped(int index) {
    selectedIndex.value = index;
  }
}
