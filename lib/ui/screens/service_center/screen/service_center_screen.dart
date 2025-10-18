import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/service_center/controller/service_center_controller.dart';

class ServiceCenterScreen extends StatelessWidget {
  const ServiceCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceCenterController>(
      init: ServiceCenterController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFFAC9989),
            iconTheme: const IconThemeData(color: Colors.white),
            title: controller.isSearchActive.value
                ? _SearchField(controller: controller)
                : Text(
                    'Pohon Aren (${controller.itemCount})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
            actions: [
              if (controller.isSearchActive.value)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: controller.stopSearch,
                  tooltip: 'Batal cari',
                )
              else
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: controller.startSearch,
                  tooltip: 'Cari',
                ),
            ],
            centerTitle: false,
            elevation: 0,
          ),
          body: Stack(
            children: [
              if (!controller.showEmpty)
                RefreshIndicator(
                  color: const Color(0xFFAC9989),
                  onRefresh: controller.refreshItems,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 72),
                    itemCount: controller.itemCount,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return _ServiceCenterListItem(
                        key: ValueKey(item.idSupplier),
                        item: item,
                        onTap: () => controller.gotoDetail(item),
                        onDismissed: (direction) =>
                            controller.removeItem(context, item, index),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                )
              else
                const _EmptyState(),
              if (controller.isLoading.value)
                const _LoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final ServiceCenterController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchCtrl,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Cari service center...',
        hintStyle: TextStyle(color: Color(0xFFEFEFEF)),
        border: InputBorder.none,
      ),
      onChanged: controller.onSearchChanged,
    );
  }
}

class _ServiceCenterListItem extends StatelessWidget {
  const _ServiceCenterListItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDismissed,
  });

  final ServiceCenterItem item;
  final VoidCallback onTap;
  final DismissDirectionCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final dismissKey = ValueKey('service-${item.idSupplier}');
    return Dismissible(
      key: dismissKey,
      background: _SwipeBackground(
        alignment: Alignment.centerLeft,
        icon: Icons.delete,
        label: 'REMOVE',
      ),
      secondaryBackground: _SwipeBackground(
        alignment: Alignment.centerRight,
        icon: Icons.delete,
        label: 'REMOVE',
      ),
      direction: DismissDirection.horizontal,
      onDismissed: onDismissed,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/drawable/icon_aren.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.supplierName.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFFAC9989),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.plainAddress,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.plainCity,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.phone?.trim().isEmpty ?? true
                                ? '-'
                                : item.phone!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.icon,
    required this.label,
  });

  final Alignment alignment;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: const Color(0xFFD62E49),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerRight)
            const SizedBox.shrink()
          else
            Icon(icon, color: Colors.white),
          if (alignment == Alignment.centerLeft) const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (alignment == Alignment.centerRight) ...[
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/drawable/no_data.png',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            'Data tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.05),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAC9989)),
        ),
      ),
    );
  }
}
