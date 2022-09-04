import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/authentication/auth_button.dart';
import 'package:sportsapp/widgets/form_error.dart';

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

  final TextEditingController _emailController =
      TextEditingController(text: "edem.agbakpe@icloud.com");

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController =
      TextEditingController(text: "Edem.com");
  final TextEditingController _bioController =
      TextEditingController(text: "I love BENZEMA!");

  // Future<void> uploadPfP() async {
  //   try {
  //     File? uploadFile = File(imageFile!.path);
  //     Reference storageRef =
  //         storage.ref().child('profile_pics/${uploadFile.path}');
  //     UploadTask uploadTask = storageRef.putFile(uploadFile);
  //     await uploadTask.whenComplete(() => print('uploaded'));
  //     print('File Uploaded');
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     // return taskSnapshot.ref.getDownloadURL();
  //     storageRef.getDownloadURL().then((fileURL) {
  //       print("File URL: $fileURL");
  //     });
  //   } catch (e) {
  //     debugPrint("UPLOADPFP FUNCTION: $e");
  //   }
  // }

  Future<void> uploadPfP() async {
    File uplaodFile = File(imageFile!.path);
    try {
      await storage.ref("profile_pics/${uplaodFile.path}").putFile(
            uplaodFile,
          );
    } catch (e) {
      debugPrint("UPLOADPFP FUNCTION: $e");
    }
  }

  Future<String?> getDownload() async {
    File? uploadedFile = File(imageFile!.path);
    var ref = await storage
        .ref()
        .child('profile_pics/${uploadedFile.path}')
        .getDownloadURL();

    return ref;
  }

  // Future<String> getDownload() async {
  //   File? uploadFile = File(imageFile!.path);
  //   var ref = await storage
  //       .ref()
  //       .child('profile_pics/${uploadFile.path}')
  //       .getDownloadURL();

  //   return ref;
  // }

  TextFormField buildFullNameFormField() {
    return TextFormField(
      controller: _fullNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Display Name is required";
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Display Name",
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
        hintText: "Enter Display Name",
        // floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildAvatar() {
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
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage(AppImage.defaultProfilePicture2),
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
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // void _getFromCamera() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     maxHeight: 720,
  //     maxWidth: 720,
  //   );
  //   setState(() {
  //     imageFile = File(pickedFile!.path);
  //   });
  // }

  // void _getFromGallery() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 720,
  //     maxWidth: 720,
  //   );
  //   setState(() {
  //     imageFile = File(pickedFile!.path);
  //   });
  // }

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

  // @override
  // void initState() {
  //   super.initState();
  //   var authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   authProvider.setIsLoading(false);
  // }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

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
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  //   decoration: BoxDecoration(
                  //     color: kGrey.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(32),
                  //   ),
                  //   child: buildFullNameFormField(),
                  // ),
                  // const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    // decoration: const BoxDecoration(
                    //   // color: kGrey.withOpacity(0.1),
                    //   // borderRadius: BorderRadius.circular(32),
                    // ),
                    child: buildAvatar(),
                  ),
                  const SizedBox(height: 40),
                  // const SizedBox(height: 10),
                  // const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    decoration: BoxDecoration(
                      color: kGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: buildFullNameFormField(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    decoration: BoxDecoration(
                      color: kGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: buildFullNameFormField(),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
