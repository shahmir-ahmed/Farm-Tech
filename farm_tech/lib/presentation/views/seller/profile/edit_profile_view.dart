import 'dart:io';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/services/seller_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView(
      {required this.docId,
      required this.name,
      required this.email,
      required this.profileImageUrl,
      required this.getSellerName,
      required this.getProfileImage});

  String docId;
  String name;
  String email;
  String profileImageUrl;
  // profile screen method
  VoidCallback getProfileImage;
  VoidCallback getSellerName;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  String profileImageUrl = '';
  String name = '';
  String email = '';
  String newName = '';

  File? pickedImage;

  // reg exp variable for name field
  static final RegExp nameRegExp = RegExp(r'^[A-Za-z ]+$');

  // select source to upload image i.e. gallery/camera
  void mediaPickerOptions(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Pic image from",
                    style: Utils.kAppHeading6BoldStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    primaryButton: true,
                    secondaryButton: false,
                    onButtonPressed: () {
                      // close this modal bottom sheet
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                    buttonText: "Camera",
                    buttonHeight: 50,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomButton(
                    primaryButton: true,
                    secondaryButton: false,
                    onButtonPressed: () {
                      // close this modal bottom sheet
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                    buttonText: "Gallery",
                    buttonHeight: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Pick image
  void pickImage(ImageSource imageType) async {
    try {
      // app crashes if heavy image is selected (so not more than 15mb image should be allowed to be uploaded)
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;

      const maxFileSize = 5 * 1024 * 1024; // 10 MB in bytes

      // if image size is more than 10mb show error
      if (File(photo.path).lengthSync() > maxFileSize) {
        // print('large image');
        floatingSnackBar(
            message:
                'The image you are trying to upload is too large. The maximum file size allowed is 5 MB. Please select a smaller image.',
            context: context,
            duration: const Duration(seconds: 6));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     duration: Duration(seconds: 6),
        //     content: Text(
        //         'The image you are trying to upload is too large. The maximum file size allowed is 10 MB.  Please select a smaller image.')));
        // return; (not closes the modal sheet so snackbar not visible so commented this)
      } else {
        // print('photo.path: ${photo.path}'); // jpg file

        // if image is less than or equal to 10MB
        // compress photo using flutter image compress package
        File? tempImage = await compressFile(File(photo.path));

        // if error compressing
        if (tempImage == null) tempImage = File(photo.path);

        // print(photo.path); // jpg file

        // print('tempImage.path: ${tempImage.path}');

        // update the image and error variable and notify the widget to update its state using setState
        setState(() {
          pickedImage = tempImage;
        });
      }

      // Close the image picker screen (but it closes the modal bottom sheet)
      // Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // flutter_image_compress
  // The flutter_image_compress package is fairly simple to use and it appears to be much better at actually reducing the file size.
  Future<File?> compressFile(File file) async {
    try {
      final filePath = file.absolute.path;

      // Create output file path with .jpg extension
      final outPath =
          "${filePath.substring(0, filePath.lastIndexOf('.'))}_out.jpg";

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        format: CompressFormat.jpeg, // Ensure the format is set to JPEG
        quality: 25,
      );

      if (result == null) {
        print("Compression failed");
        return null;
      }

      print('Original file size: ${file.lengthSync()} bytes');
      result
          .length()
          .then((value) => print('Compressed file size: ${value} bytes'));

      return File(result.path);
    } catch (e) {
      print("Error in compressing image: $e");
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.name;
    email = widget.email;
    profileImageUrl = widget.profileImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppbar(),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getAppbar() {
    return Utils.getAppBar('Edit Profile', [], context);
  }

  _getBody() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // space
                const SizedBox(
                  height: 20,
                ),

                // user image
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 300,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: pickedImage != null
                              ? FileImage(
                                  pickedImage!,
                                )
                              : NetworkImage(
                                  widget.profileImageUrl,
                                ),
                        ),

                        // edit button
                        SizedBox(
                          height: 120,
                          child: Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: GestureDetector(
                              onTap: () {
                                // show image picker screen
                                mediaPickerOptions(context);
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Utils.greenColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                      child: Image.asset(
                                          'assets/images/edit-icon.png',
                                          width: 25))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // form
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // user name field
                          TextFormField(
                            initialValue: name,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              setState(() {
                                newName = value.trim();
                              });
                            },
                            decoration: Utils.inputFieldDecoration
                                .copyWith(hintText: 'Name'),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Name is required';
                              }
                              // contains characters other than alphabets
                              else if (!nameRegExp.hasMatch(value)) {
                                return 'Please enter valid name';
                              }
                              return null;
                            },
                            style: Utils.kAppBody3MediumStyle,
                          ),

                          // space
                          const SizedBox(
                            height: 30,
                          ),

                          // user email field (disabled)
                          TextFormField(
                            initialValue: email,
                            enabled: false,
                            decoration: Utils.inputFieldDecoration,
                            style: Utils.kAppBody3MediumStyle,
                          ),
                        ],
                      )),
                ),
              ],
            ),
            // save changes button at end
            CustomButton(
              buttonText: "Save Changes",
              onButtonPressed: () async {
                // if form is valid
                if (_formKey.currentState!.validate()) {
                  // show loading alert dialog
                  Utils.showLoadingAlertDialog(context, 'edit_profile');

                  // if new name is changed
                  if (newName.isNotEmpty) {
                    // if new name is not same as current name then update name
                    if (name != newName) {
                      final result = await SellerServices().updateSellerName(
                          SellerModel(docId: widget.docId, name: newName));

                      if (result == "success") {
                        print('name updated');
                        // cal previous screen get seller name method
                        widget.getSellerName();
                      }
                    }
                  }

                  // if picked image is present then update profile image
                  if (pickedImage != null) {
                    final result2 = await SellerServices().updateProfileImage(
                        SellerModel(
                            docId: widget.docId,
                            profileImageUrl: pickedImage!.path));

                    if (result2 == 'success') {
                      print('image updated');
                      // call previous screen get profile image method
                      widget.getProfileImage();
                    }
                  }

                  // close alert dialog
                  Navigator.pop(context);

                  // close screen
                  Navigator.pop(context);

                  // show success message
                  floatingSnackBar(
                      message: 'Profile updated!', context: context);
                }
              },
              primaryButton: true,
              secondaryButton: false,
              buttonWidth: MediaQuery.of(context).size.width - 50,
              buttonHeight: 60,
            ),
          ],
        ),
      ),
    );
  }
}
