import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/ui/screens/account/controller/edit_user_controller.dart';

class EditUserScreen extends StatelessWidget {
  const EditUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditUserController>(
      init: EditUserController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Ubah Data',
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
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (controller.showName) ...[
                    const _SectionIntro(
                      title: 'Apa nama anda?',
                      subtitle:
                          'Lengkapi nama Anda agar mudah dikenali oleh pengguna lain.',
                    ),
                    _TextField(
                      controller: controller.nameCtrl,
                      hint: 'Masukkan nama anda..',
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (controller.showIdCard) ...[
                    const _SectionIntro(
                      title: 'Nomor Identitas',
                      subtitle:
                          'Lengkapi nomor KTP Anda sesuai data resmi.',
                    ),
                    _TextField(
                      controller: controller.idCardCtrl,
                      hint: 'Masukkan nomor KTP anda..',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (controller.showGender) ...[
                    const _SectionIntro(
                      title: 'Jenis Kelamin',
                      subtitle: 'Pilih identitas gender Anda saat ini.',
                    ),
                    Obx(
                      () => DropdownButtonFormField<int>(
                        value: controller.selectedGenderIndex.value,
                        items: List.generate(
                          controller.genderOptions.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(controller.genderOptions[index]),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedGenderIndex.value = value;
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (controller.showAddress) ...[
                    const _SectionIntro(
                      title: 'Alamat',
                      subtitle: 'Masukkan alamat terbaru Anda.',
                    ),
                    _TextField(
                      controller: controller.addressCtrl,
                      hint: 'Masukkan alamat anda..',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (controller.showEmail) ...[
                    const _SectionIntro(
                      title: 'Email',
                      subtitle:
                          'Pastikan email aktif agar mudah dihubungi tim kami.',
                    ),
                    _TextField(
                      controller: controller.emailCtrl,
                      hint: 'Masukkan email anda..',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (controller.showPhone) ...[
                    const _SectionIntro(
                      title: 'Nomor Telepon',
                      subtitle: 'Masukkan nomor yang aktif dan bisa dihubungi.',
                    ),
                    _TextField(
                      controller: controller.phoneCtrl,
                      hint: 'Masukkan nomor telepon anda..',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (controller.showUsername) ...[
                    const _SectionIntro(
                      title: 'Username',
                      subtitle:
                          'Username digunakan saat login ke aplikasi SIKAP-AREN.',
                    ),
                    _TextField(
                      controller: controller.usernameCtrl,
                      hint: 'Masukkan username anda..',
                    ),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save_outlined),
                      label: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D918E),
                      ),
                      onPressed: controller.submit,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
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
              if (controller.isLoading.value)
                const _LoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
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
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
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
