// lib/ui/screens/main/screen/main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/_index.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          flexibleSpace: _buildCustomAppBar(),
        ),
        body: _buildBody(controller.selectedIndex.value),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onTabTapped,
          selectedItemColor: const Color(0xFF9F8768),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Image.asset('assets/drawable/logo_pnp.png', width: 40, height: 40),
            const SizedBox(width: 12),
            const Text(
              'Kementerian Kehutanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int idx) {
    switch (idx) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ProfileScreen(); // <-- now shows the Profile tab UI
      default:
        return const Center(child: Text('Unknown'));
    }
  }
}
