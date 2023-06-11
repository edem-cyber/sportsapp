import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // File? imageFile;

  // var isLoading = false;

  //image picker
  final _picker = ImagePicker();
  XFile? imageFile;

  // Future pickImage() async {
  //   try {
  //     File file = File(imageFile!.path);
  //     // imageFile = await picker.pickImage(
  //     //     source: ImageSource.gallery, imageQuality: 25) as File;
  //     if (imageFile == null) return;

  //     final imageTemporary = File(imageFile!.path);

  //     setState(() {
  //       imageFile = imageTemporary;
  //     });
  //   } on PlatformException catch (e) {
  //     appNotification(
  //         title: "Error",
  //         message: "Failed to pick image",
  //         icon: const Icon(Icons.error));
  //   } on Exception catch (e) {
  //     debugPrint("Error pick image function: $e");
  //   }
  // }

  //firebase storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Future<void> uploadPfP() async {
  //   try {
  //     File? uploadFile = File(imageFile!.path);
  //     Reference storageRef =
  //         storage.ref().child('profile_pics/${uploadFile.path}');
  //     UploadTask uploadTask = storageRef.putFile(uploadFile);
  //     await uploadTask.whenComplete(() => debugPrint('uploaded'));
  //     debugPrint('File Uploaded');
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     // return taskSnapshot.ref.getDownloadURL();
  //     storageRef.getDownloadURL().then((fileURL) {
  //       debugPrint("File URL: $fileURL");
  //     });
  //   } catch (e) {
  //     debugPrint("UPLOADPFP FUNCTION: $e");
  //   }
  // }

  // Future<String?> uploadPfP() async {
  //   File uploadedFile = File(imageFile!.path);
  //   //VAR DATETIME TO miliseconds
  //   var now = DateTime.now().millisecondsSinceEpoch;
  //   TaskSnapshot? taskSnapshot =
  //       await storage.ref("images/profile_pics/$now").putFile(
  //             uploadedFile,
  //           );

  //   // try {
  //   //   // String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //   // } catch (e) {
  //   //   debugPrint("UPLOADPFP FUNCTION: $e");
  //   // }

  //   return taskSnapshot.ref.getDownloadURL();
  // }

  // Future<String> getDownload() async {
  //   File? uploadFile = File(imageFile!.path);
  //   var ref = await storage
  //       .ref()
  //       .child('profile_pics/${uploadFile.path}')
  //       .getDownloadURL();

  //   return ref;
  // }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
  }

  TextFormField buildDisplayNameFormField() {
    return TextFormField(
      controller: _displayNameController,
      validator: (value) {
        if (value!.isEmpty) {
          //   // return "Display Name is required";
          // } else if (value.length < 3) {
          //   return "Display Name must be at least 3 characters";
          return null;
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Full Name",
        // floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildBioFormField() {
    return TextFormField(
      controller: _bioController,
      validator: (value) {
        if (value!.isEmpty) {
          return null;
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Bio",
        // floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildAvatar(String? imageUrl) {
    return GestureDetector(
      onTap: () {
        pickImage();
      },
      child: imageFile != null
          ? CircleAvatar(
              backgroundImage: FileImage(File(imageFile!.path)),
              radius: 50,
            )
          : SizedBox(
              width: 115,
              height: 115,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        imageUrl ?? AppImage.defaultProfilePicture),
                    radius: 50,
                  ),
                  Positioned(
                    bottom: 0,
                    right: -25,
                    child: RawMaterialButton(
                      onPressed: () {
                        pickImage();
                      },
                      elevation: 2.0,
                      fillColor: const Color(0xFFF5F6F9),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: kBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void pickImage() async {
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    setState(() {
      this.imageFile = imageFile;
      // if (imageFile != null) Image.file(File(imageFile.path));
    });
  }

  Future<String?> uploadPfP() async {
    try {
      File? uploadedFile = File(imageFile!.path);
      //VAR DATETIME TO miliseconds
      var now = DateTime.now().millisecondsSinceEpoch;
      TaskSnapshot? taskSnapshot =
          await storage.ref("images/profile_pics/$now").putFile(
                uploadedFile,
              );
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("UPLOADPFP FUNCTION!!: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var navigationService =
        Provider.of<NavigationService>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: ListView(
        children: [
          const Text(
            "Input necessary details to update your personal information",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: buildAvatar(
                      authProvider.user!.photoURL,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    decoration: BoxDecoration(
                      color: kGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: buildDisplayNameFormField(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    decoration: BoxDecoration(
                      color: kGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: buildBioFormField(),
                  ),
                  const SizedBox(height: 18),

                  //save button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    // width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            String? value = await uploadPfP();
                            String displayName = _displayNameController.text;
                            String bio = _bioController.text;

                            if (displayName.isNotEmpty) {
                              await authProvider.updateDisplayName(displayName);
                            }

                            if (bio.isNotEmpty) {
                              await authProvider.updateBio(bio);
                            }

                            if (value != null) {
                              await authProvider.updatePhotoUrl(value);
                            }

                            navigationService.goBack();
                          } else {
                            debugPrint("Form is not valid");
                          }
                        } catch (e) {
                          if (e is FirebaseException) {
                            debugPrint("AUTH BUTTON FIREBASE EXCEPTION $e");
                            // Handle FirebaseException error
                          } else {
                            debugPrint("AUTH BUTTON EXCEPTION $e");
                            // Handle other exceptions
                          }
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
