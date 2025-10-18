// lib/ui/screens/inventaris/screen/inventaris_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../identitas/screen/identitas_screen.dart';
import '../../produksi/screen/produksi_screen.dart';
import '../../lingkungan/screen/lingkungan_screen.dart';
import '../../product/screen/product_screen.dart';
import '../../proses/screen/proses_screen.dart';
import '../controller/inventaris_controller.dart';

class InventarisScreen extends StatelessWidget {
  const InventarisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventarisController>(
      init: InventarisController(),
      builder: (ctl) {
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            backgroundColor: const Color(0xFFF5ECE4), // soft beige background
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: AppBar(
                // backgroundColor: const Color(0xFF4D918E), // primary green tone
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'Inventaris',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                bottom: const TabBar(
                  isScrollable: true,
                  indicatorColor: Color(0xFFFFC107),
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xFFDDDDDD),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  tabs: [
                    Tab(text: 'Informasi'),
                    Tab(text: 'Penyayatan'),
                    Tab(text: 'Penyadap'),
                    Tab(text: 'Produk'),
                    Tab(text: 'Proses'),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child:
                      ctl.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : const TabBarView(
                            children: [
                              IdentitasScreen(),
                              ProduksiScreen(),
                              LingkunganScreen(),
                              ProductScreen(),
                              ProsesScreen(),
                            ],
                          ),
                ),

                // --- bottom button ---
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: ElevatedButton.icon(
                    icon:
                        ctl.isSaving.value
                            ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Simpan Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50), // green
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed:
                        ctl.isSaving.value ? null : () => ctl.confirmSave(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
