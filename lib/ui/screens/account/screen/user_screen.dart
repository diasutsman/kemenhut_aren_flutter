import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/ui/screens/account/controller/user_controller.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (controller) {
        final profile = controller.profile.value;
        final showOverlay =
            controller.isLoading.value || controller.isUploadingPhoto.value;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'My Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFB7997A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: Get.back,
            ),
          ),
          body: Stack(
            children: [
              RefreshIndicator(
                color: const Color(0xFFB7997A),
                onRefresh: controller.refreshData,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: controller.onShowPhoto,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child:
                                      profile?.photo.isNotEmpty == true &&
                                              !controller.isOffline.value
                                          ? Image.network(
                                              profile!.photo,
                                              width: 96,
                                              height: 96,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Image.asset(
                                                'assets/drawable/default_user_icon.png',
                                                width: 96,
                                                height: 96,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              'assets/drawable/default_user_icon.png',
                                              width: 96,
                                              height: 96,
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                              if (controller.canEdit)
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: controller.onChangePhoto,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Image.asset(
                                          'assets/drawable/camera_icon.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.fullName ?? '-',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile?.roleName ?? '-',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                controller.canEdit
                                    ? TextButton(
                                      onPressed:
                                          () => controller.onEditField(
                                            AppSettings.FIELD_PHONE,
                                          ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFFD62E49,
                                        ),
                                        padding: EdgeInsets.zero,
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      child: Text(profile?.phone ?? '-'),
                                    )
                                    : Text(
                                      profile?.phone ?? '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFD62E49),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoSection(
                      title: 'Nama',
                      value: profile?.fullName ?? '-',
                      onTap:
                          () => controller.onEditField(AppSettings.FIELD_NAME),
                      editable: controller.canEdit,
                    ),
                    _InfoSection(
                      title: 'Username',
                      value: profile?.userName ?? '-',
                      onTap:
                          () => controller.onEditField(
                            AppSettings.FIELD_USERNAME,
                          ),
                      editable: controller.canEdit,
                    ),
                    _InfoSection(
                      title: 'Partner Name',
                      value: profile?.roleName ?? '-',
                      editable: false,
                    ),
                    _InfoSection(
                      title: 'Email',
                      value: profile?.email ?? '-',
                      onTap:
                          () => controller.onEditField(AppSettings.FIELD_EMAIL),
                      editable: controller.canEdit,
                    ),
                    _InfoSection(
                      title: 'Nomor KTP',
                      value: profile?.idCard ?? '-',
                      onTap:
                          () =>
                              controller.onEditField(AppSettings.FIELD_IDCARD),
                      editable: controller.canEdit,
                    ),
                    _InfoSection(
                      title: 'Jenis Kelamin',
                      value: profile?.gender ?? '-',
                      onTap:
                          () =>
                              controller.onEditField(AppSettings.FIELD_GENDER),
                      editable: controller.canEdit,
                    ),
                    _InfoSection(
                      title: 'Alamat',
                      value: profile?.address ?? '-',
                      onTap:
                          () =>
                              controller.onEditField(AppSettings.FIELD_ADDRESS),
                      editable: controller.canEdit,
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: controller.onCall,
                          icon: Image.asset(
                            'assets/drawable/phone_icon.png',
                            width: 24,
                            height: 24,
                            color: const Color(0xFF2E7D32),
                          ),
                          label: const Text(
                            'Call',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 56,
                        color: const Color(0xFFD5D5D5),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: controller.onMessage,
                          icon: Image.asset(
                            'assets/drawable/message_icon.png',
                            width: 24,
                            height: 24,
                            color: const Color(0xFF265A91),
                          ),
                          label: const Text(
                            'Message',
                            style: TextStyle(
                              color: Color(0xFF265A91),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Visibility(
                    visible: controller.isOffline.value,
                    child: const _NoConnectivityBanner(),
                  ),
                ),
              ),
              if (showOverlay) const _LoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.value,
    this.onTap,
    required this.editable,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: editable ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value.isEmpty ? '-' : value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (editable)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoConnectivityBanner extends StatelessWidget {
  const _NoConnectivityBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      color: const Color(0xFFD62E49),
      child: const Text(
        'No Internet Connection',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB7997A)),
        ),
      ),
    );
  }
}
