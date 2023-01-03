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

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final List<String?> errors = [];
  // File? imageFile;

  // var isLoading = false;

  bool obscureText = true;

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

  final TextEditingController _confirmPasswordController =
      TextEditingController(text: "1234567");

  final TextEditingController _emailController =
      TextEditingController(text: "edem.agbakpe@icloud.com");

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController =
      TextEditingController(text: "Edem Agbakpe");

  final TextEditingController _passwordController =
      TextEditingController(text: "1234567");

  final TextEditingController _usernameController =
      TextEditingController(text: "edem-cyber");

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

  Future<String?> uploadPfP() async {
    try {
      File? uploadedFile = File(imageFile!.path);
      //VAR DATETIME TO miliseconds
      var now = DateTime.now().millisecondsSinceEpoch;
      TaskSnapshot? taskSnapshot =
          await storage.ref("images/profile_pics/$now").putFile(
                uploadedFile,
              );
      return taskSnapshot != null
          ? await taskSnapshot.ref.getDownloadURL()
          : "";
    } catch (e) {
      print("UPLOADPFP FUNCTION!!: $e");
    }
  }

  // Future<String?> getDownload() async {
  //   var now = DateTime.now().millisecondsSinceEpoch;
  //   File? uploadedFile = File(imageFile!.path);
  //   var ref =
  //       await storage.ref().child('images/profile_pics/$now}').getDownloadURL();
  //   return ref;
  // }

  // Future<String> getDownload() async {
  //   File? uploadFile = File(imageFile!.path);
  //   var ref = await storage
  //       .ref()
  //       .child('profile_pics/${uploadFile.path}')
  //       .getDownloadURL();

  //   return ref;
  // }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: _usernameController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Username is required";
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Username",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDisplayNameFormField() {
    return TextFormField(
      controller: _displayNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Display Name is required";
        } else if (value.length < 3) {
          return "Display Name must be at least 3 characters";
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }

        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Email",
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: obscureText,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 7) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: obscureText,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        } else if (value != _passwordController.text) {
          addError(error: kPassMatchError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 7) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        // contentPadding: contentPadding,
        hintText: "Confirm password",
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
          : const CircleAvatar(
              backgroundImage: AssetImage(AppImage.defaultProfilePicture2),
              radius: 50,
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

  pickImage() async {
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
    //authprovider
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    //set is loading
    // authProvider.setIsLoading(false);

    // var isLoading = authProvider.isLoading ?? false;
    // authProvider.setIsLoading(false);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          //   decoration: BoxDecoration(
          //     color: kGrey.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(32),
          //   ),
          //   child: buildDisplayNameFormField(),
          // ),
          // const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: buildAvatar(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildUsernameFormField(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildDisplayNameFormField(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildEmailFormField(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildPasswordFormField(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildConfirmPasswordFormField(),
          ),
          const SizedBox(height: 26),
          FormError(errors: errors),
          const SizedBox(height: 18),

          AuthButton(
            textColor: kWhite,
            color: kBlue,
            text: "Sign Up",
            press: () async {
              var isdupli =
                  await authProvider.checkDuplicate(_usernameController.text);
              if (isdupli == false) {
                bool passwordMatch =
                    _passwordController.text == _confirmPasswordController.text;
                try {
                  if (_formKey.currentState!.validate()) {
                    try {
                      String? value = await uploadPfP();
                      await authProvider.signUp(
                        photoURL: value ?? "",
                        displayName: _displayNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        username: _usernameController.text,
                      );
                    } catch (e) {
                      debugPrint("error in uploadPfP");
                    }
                  } else if (passwordMatch) {
                    addError(error: kPassMatchError);
                  } else {
                    addError(error: kPassNullError);
                  }
                } on FirebaseException catch (e) {
                  debugPrint("AUTH BUTTON FIREBASE EXCEPTION $e");
                  // addError(error: kEmailNullError);
                } catch (e) {
                  debugPrint("AUTH BUTTON EXCEPTION $e");
                  // addError(error: kEmailNullError);
                }
              } else {
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
