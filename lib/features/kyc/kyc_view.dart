// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:influencer/core/theme/app_colors.dart';
// import 'package:influencer/core/utils/responsive.dart';
// import 'package:influencer/data/models/kyc_models.dart';
// import 'kyc_controller.dart';
//
// class KycView extends GetView<KycController> {
//   const KycView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final resp = context.responsive;
//
//     return Scaffold(
//       body: Obx(() {
//         final profile = controller.profile.value;
//         if (profile == null) {
//           return const Center(child: Text('No profile data found.'));
//         }
//
//         final nameCtrl = TextEditingController(text: profile.name);
//         final emailCtrl = TextEditingController(text: profile.email);
//         final phoneCtrl = TextEditingController(text: profile.phone);
//         final addressCtrl = TextEditingController(text: profile.address);
//
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(resp.spacing(16)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile avatar
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: resp.isTablet ? 60 : 50,
//                       backgroundColor: AppColors.primary,
//                       backgroundImage: controller.profileImage.value != null
//                           ? FileImage(controller.profileImage.value!)
//                           : null,
//                       child: controller.profileImage.value == null
//                           ? Icon(Icons.person,
//                           size: resp.isTablet ? 60 : 50,
//                           color: Colors.white)
//                           : null,
//                     ),
//                     Positioned(
//                       bottom: 4,
//                       right: 4,
//                       child: Container(
//                         height: 30,
//                         width: 30,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 2),
//                         ),
//                         child: PopupMenuButton<String>(
//                           padding: EdgeInsets.zero,
//                           offset: const Offset(0, -100),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                           icon: const Icon(Icons.camera_alt,
//                               color: Colors.white, size: 16),
//                           onSelected: (value) {
//                             if (value == 'camera') {
//                               controller.takePhoto();
//                             } else if (value == 'gallery') {
//                               controller.pickImage();
//                             }
//                           },
//                           itemBuilder: (context) => [
//                             const PopupMenuItem(
//                               value: 'camera',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.camera_alt),
//                                   SizedBox(width: 8),
//                                   Text('Take Photo'),
//                                 ],
//                               ),
//                             ),
//                             const PopupMenuItem(
//                               value: 'gallery',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.photo_library),
//                                   SizedBox(width: 8),
//                                   Text('Choose from Gallery'),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: resp.spacing(16)),
//
//               // Name
//               Text('Name', style: Theme.of(context).textTheme.labelLarge),
//               TextFormField(controller: nameCtrl,
//                   decoration: const InputDecoration(border: OutlineInputBorder())),
//               SizedBox(height: resp.spacing(12)),
//
//               // Email
//               Text('Email', style: Theme.of(context).textTheme.labelLarge),
//               TextFormField(controller: emailCtrl,
//                   decoration: const InputDecoration(border: OutlineInputBorder())),
//               SizedBox(height: resp.spacing(12)),
//
//               // Phone
//               Text('Phone', style: Theme.of(context).textTheme.labelLarge),
//               TextFormField(controller: phoneCtrl,
//                   decoration: const InputDecoration(border: OutlineInputBorder())),
//               SizedBox(height: resp.spacing(12)),
//
//               // Address
//               Text('Address', style: Theme.of(context).textTheme.labelLarge),
//               TextFormField(
//                 controller: addressCtrl,
//                 maxLines: 3,
//                 decoration: const InputDecoration(border: OutlineInputBorder()),
//               ),
//               SizedBox(height: resp.spacing(16)),
//
//               // 🔹 KYC Document Upload
//               Text('KYC Documents',
//                   style: Theme.of(context).textTheme.labelLarge),
//               SizedBox(height: resp.spacing(8)),
//               Obx(() => Wrap(
//                 spacing: 8,
//                 children: [
//                   ...controller.kycDocuments.map((doc) => ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.file(doc,
//                         width: 80, height: 80, fit: BoxFit.cover),
//                   )),
//                   GestureDetector(
//                     onTap: controller.pickKycDocument,
//                     child: Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.primary),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.add, color: AppColors.primary),
//                     ),
//                   ),
//                 ],
//               )),
//               SizedBox(height: resp.spacing(20)),
//
//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final updatedProfile = Profile(
//                       name: nameCtrl.text,
//                       email: emailCtrl.text,
//                       phone: phoneCtrl.text,
//                       address: addressCtrl.text,
//                     );
//                     controller.updateProfile(updatedProfile);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding:
//                     EdgeInsets.symmetric(vertical: resp.spacing(12)),
//                   ),
//                   child: const Text('Save Changes'),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/data/models/kyc_models.dart';
import 'kyc_controller.dart';
import 'dart:io';

class KycView extends GetView<KycController> {
  const KycView({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;

    return Scaffold(
      body: Obx(() {
        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        String _na(String v) => (v.isEmpty) ? 'N/A' : v;
        final nameCtrl = TextEditingController(text: _na(profile.name));
        final emailCtrl = TextEditingController(text: _na(profile.email));
        final phoneCtrl = TextEditingController(text: _na(profile.phone));
        final addressCtrl = TextEditingController(text: _na(profile.address));
        final cityCtrl = TextEditingController(text: _na(profile.city));
        final stateCtrl = TextEditingController(text: _na(profile.state));
        final zipCtrl = TextEditingController(text: _na(profile.zipCode));
        final countryCtrl = TextEditingController(text: _na(profile.country));
        final genderCtrl = TextEditingController(text: _na(profile.gender));
        final dobCtrl = TextEditingController(text: _na(profile.dateOfBirth));
        final nationalityCtrl = TextEditingController(text: _na(profile.nationality));
        final roleCtrl = TextEditingController(text: _na(profile.role));

        return SingleChildScrollView(
          padding: EdgeInsets.all(resp.spacing(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: resp.isTablet ? 60 : 50,
                      backgroundColor: AppColors.primary,
                      backgroundImage: controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!)
                          : null,
                      child: controller.profileImage.value == null
                          ? Icon(Icons.person,
                          size: resp.isTablet ? 60 : 50,
                          color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => Wrap(children: [
                                ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Take Photo'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      controller.takePhoto();
                                    }),
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Choose from Gallery'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      controller.pickImage();
                                    }),
                              ]));
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 16,
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: resp.spacing(16)),

              // All profile fields
              ..._buildTextField('Name', nameCtrl),
              ..._buildTextField('Email', emailCtrl,
                  keyboardType: TextInputType.emailAddress, readOnly: true),
              ..._buildTextField('Phone', phoneCtrl,
                  keyboardType: TextInputType.phone, readOnly: true),
              ..._buildTextField('Address', addressCtrl),
              ..._buildTextField('City', cityCtrl),
              ..._buildTextField('State', stateCtrl),
              ..._buildTextField('Zip Code', zipCtrl,
                  keyboardType: TextInputType.number),
              ..._buildTextField('Country', countryCtrl),
              ..._buildTextField('Gender', genderCtrl),
              ..._buildTextField('Date of Birth', dobCtrl),
              ..._buildTextField('Nationality', nationalityCtrl),
              ..._buildTextField('Role', roleCtrl),

              SizedBox(height: resp.spacing(16)),

              // KYC Documents
              Text('KYC Documents', style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: resp.spacing(8)),
              Obx(() => Wrap(
                spacing: 8,
                children: [
                  ...controller.kycDocuments.map((doc) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(doc,
                        width: 80, height: 80, fit: BoxFit.cover),
                  )),
                  GestureDetector(
                    onTap: controller.pickKycDocument,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                      const Icon(Icons.add, color: AppColors.primary),
                    ),
                  ),
                ],
              )),
              SizedBox(height: resp.spacing(20)),

              // Save button
              SizedBox(
                width: double.infinity,
                child:
                ElevatedButton(
                  onPressed: () {
                    final updatedProfile = Profile(
                      id: profile.id,
                      name: nameCtrl.text,
                      email: emailCtrl.text,
                      phone: phoneCtrl.text,
                      address: addressCtrl.text,
                      city: cityCtrl.text,
                      state: stateCtrl.text,
                      zipCode: zipCtrl.text,
                      country: countryCtrl.text,
                      gender: genderCtrl.text,
                      dateOfBirth: dobCtrl.text,
                      nationality: nationalityCtrl.text,
                      role: roleCtrl.text,
                    );
                    controller.updateProfileApi(updatedProfile); // <-- Corrected method
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: resp.spacing(12)),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildTextField(String label, TextEditingController ctrl,
      {TextInputType keyboardType = TextInputType.text, bool readOnly = false}) {
    return [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 4),
      TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      SizedBox(height: 12),
    ];
  }
}

