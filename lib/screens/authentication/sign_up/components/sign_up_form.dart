import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/authentication/auth_button.dart';
import 'package:sportsapp/widgets/default_button.dart';
import 'package:sportsapp/widgets/form_error.dart';
import 'package:sportsapp/widgets/notification.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final List<String?> errors = [];
  // var isLoading = false;

  bool obscureText = true;

  final TextEditingController _confirmPasswordController =
      TextEditingController(text: "1234567");

  final TextEditingController _emailController =
      TextEditingController(text: "edem.agbakpe@icloud.com");

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController =
      TextEditingController(text: "Edem.com");

  final TextEditingController _passwordController =
      TextEditingController(text: "1234567");

  final TextEditingController _usernameController =
      TextEditingController(text: "edem-cyber");

  //image picker
  final picker = ImagePicker();
  File? _photo;

  Future pickImage() async {
    try {
      File file = File(_photo!.path);
      // _photo = await picker.pickImage(
      //     source: ImageSource.gallery, imageQuality: 25) as File;
      if (_photo == null) return;

      final imageTemporary = File(_photo!.path);

      setState(() {
        _photo = imageTemporary;
      });
    } on PlatformException catch (e) {
      appNotification(
          title: "Error",
          message: "Failed to pick image",
          icon: const Icon(Icons.error));
    } on Exception catch (e) {
      debugPrint("Error pick image function: $e");
    }
  }

  //firebase storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadPfP() async {
    File? uploadFile = File(_photo!.path);
    Reference storageRef =
        storage.ref().child('profile_pics/${uploadFile.path}');
    UploadTask uploadTask = storageRef.putFile(uploadFile);
    await uploadTask.whenComplete(() => print('uploaded'));
    print('File Uploaded');
    storageRef.getDownloadURL().then((fileURL) {
      print(fileURL);
    });
  }

  Future<String> getDownload() async {
    File? uploadFile = File(_photo!.path);
    var ref = await storage
        .ref()
        .child('profile_pics/${uploadFile.path}')
        .getDownloadURL();
    return ref;
  }

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

  TextFormField buildFullNameFormField() {
    return TextFormField(
      controller: _fullNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Full Name is required";
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
      child: CircleAvatar(
        backgroundImage: _photo != null
            ? Image.file(_photo!).image
            : const NetworkImage(AppImage.defaultProfilePicture),
        radius: 40,
        child: _photo == null
            ? const Icon(
                Icons.add,
                size: 40,
              )
            : const SizedBox(),
      ),
    );
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
          //   child: buildFullNameFormField(),
          // ),
          // const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
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
              // try {
              //   // doSignIn();
              //   // _formKey.currentState!.validate() ? doSignIn() : null;
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (_) => const Base(), fullscreenDialog: true));
              bool passwordMatch =
                  _passwordController.text == _confirmPasswordController.text;
              try {
                if (_formKey.currentState!.validate()) {
                  // authProvider.setIsLoading(true);
                  print(authProvider.isLoading);
                  // authProvider.signUp(
                  //   // : _fullNameController.text,
                  //   _emailController.text,
                  //   _passwordController.text,
                  //   _usernameController.text,
                  // );
                  // .then((value) => authProvider.setIsLoading(false));
                  uploadPfP().then((value) async {});
                  String value = await getDownload();
                  authProvider.signUp(
                    _emailController.text,
                    _passwordController.text,
                    _usernameController.text,
                    value,
                  );

                  print("second print ${authProvider.isLoading}");

                  //if mounted
                  // if (!mounted) return;
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (_) => const Base(), fullscreenDialog: true));
                } else if (passwordMatch) {
                  addError(error: kPassMatchError);
                } else {
                  addError(error: kPassNullError);
                }
              } catch (e) {
                debugPrint("Auth Button Error: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
