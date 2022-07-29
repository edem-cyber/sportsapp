import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';

import 'package:sportsapp/models/User.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/screens/authentication/sign_up/sign_up.dart';
import 'package:sportsapp/services/database_service.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/widgets/notification.dart';

class AuthProvider with ChangeNotifier {
  // FirebaseAuth _auth;
  late final FirebaseAuth _auth;
  //isLoading is used to show the loading indicator when signing in or out
  bool _isLoading = false;
  get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  UserModel? _userFromFirebase(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            email: user.email!,
            // name: user.name!,
            photoURL: user.photoURL ?? AppImage.defaultProfilePicture,
            username: user.displayName ?? user.email!.split('@')[0],
          )
        : null;
  }

  late final DatabaseService _databaseService;
  late final NavigationService _navigationService;

  GoogleSignIn? _googleSignIn;
  UserModel? user;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _databaseService = DatabaseService();
    _navigationService = NavigationService();
    _auth.authStateChanges().listen(
      // ignore: no_leading_underscores_for_local_identifiers
      (_user) {
        if (_user != null) {
          _databaseService.updateUserLastSeenTime(_user.uid);
          _databaseService.getUser(_user.uid).then(
            (snapshot) {
              // * Check if the documentSnapshot exists or not.
              if (snapshot.exists) {
                final userData = snapshot.data() as Map<String, dynamic>;
                //* Check if the document object is null or not
                if (snapshot.data() != null) {
                  // user = UserModel.fromMap(userData);
                  // _userFromFirebase = user;
                  _userFromFirebase(_user);
                  print('User data IS : ${user!.toJson()}');
                }
              }
              //* Automatic navigates to the home page
              _navigationService.removeAndNavigateToRoute(Base.routeName);
            },
          );
        } else {
          // * In case the user is not null (exists), then the user must login
          _navigationService.signOutWithAnimation(SignUp.routeName);
        }
      },
    );
  }
  // AuthProvider() {
  //   _auth = FirebaseAuth.instance;
  //   _googleSignIn = GoogleSignIn();
  // }

  // Stream<UserModel?> get user {
  //   return _auth!.authStateChanges().map(_userFromFirebase);
  // }

  Future<void> signIn(String email, String password) async {
    setIsLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint('${_auth.currentUser}');
      _navigationService.removeAndNavigateToRoute(Base.routeName);

      // ignore: await_only_futures
      await appNotification(
          title: "Success",
          message: "Signed In",
          icon: const Icon(Icons.check, color: Colors.green));
    } on FirebaseAuthException {
      debugPrint('Error login user into Firebase.');
    } catch (e) {
      debugPrint('$e');
    } finally {
      setIsLoading(false);
    }
  }

  Future<UserModel?> signUp(
    String email,
    String password,
    String username,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      //database service to create a new user
      await _databaseService.createUser(
        email: email,
        name: username,
        uid: _auth.currentUser!.uid,
        // photoURL: _auth.currentUser!.photoURL!,
      );
      _isLoading = false;
      return _userFromFirebase(_auth.currentUser);
    } catch (e) {
      //regex to filter firebase error messages
      var er = e.toString().replaceRange(0, 14, '').split(']')[1].trim();
      appNotification(
        title: "Error",
        message: er,
        icon: const Icon(Icons.error, color: Colors.red),
      );
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      // setIsLoading(true);
      _isLoading = true;
      notifyListeners();
      final GoogleSignInAccount? account = await _googleSignIn?.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;

      if (googleAuth != null) {
        UserCredential? credentials = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );
        final User? user = credentials.user;
        _isLoading = false;
        notifyListeners();
        return _userFromFirebase(user);
      } else {
        appNotification(
          title: "Error",
          message: "Missing Google Auth Token",
          icon: const Icon(Icons.error, color: Colors.red),
        );
        // _isLoading = false;
        // notifyListeners();
        // throw FirebaseAuthException(
        //   code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
        //   message: 'Missing Google Auth Token',
        // );
      }
    } catch (e) {
      print(e);
      appNotification(
        title: "Error",
        message: "GOOGLE AUTH ERROR : $e",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      // _isLoading = false;
      // notifyListeners();
      return _userFromFirebase(null);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<UserModel?> signInWithFacebook() async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     final AuthCredential credential = FacebookAuthProvider.credential(
  //       //facebook CREDENTIALS

  //     );
  //     UserCredential? credentials =
  //         await _auth?.signInWithCredential(credential);
  //     return _userFromFirebase(credentials?.user);
  //   } catch (e) {
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     return _userFromFirebase(null);
  //   }
  // }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _googleSignIn?.signOut();
      //if sign out is success show notification
      appNotification(
          title: "Success",
          message: "Signed Out",
          icon: const Icon(Icons.check, color: Colors.green));
      notifyListeners();
      return;
    } catch (e) {
      debugPrint("SIGN OUT ERROR: $e");
      return;
    } finally {
      notifyListeners();
      // setIsLoading(false);
    }
  }

  // Future<bool> signInWithGoogle() async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await _auth!.signInWithCredential(credential);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future<void> _onAuthStateChanged(User firebaseUser) async {
  //   if (firebaseUser == null) {
  //     _status = Status.Unauthenticated;
  //   } else {
  //     _user = firebaseUser;
  //     _status = Status.Authenticated;
  //   }
  //   notifyListeners();
  // }
}

SnackbarController signedOutNotification(String message) => Get.snackbar(
      showProgressIndicator: false,
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 600),
      "Success",
      message,
      colorText: kWhite,
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "Cancel",
          // style: TextStyle(color: kTertiaryColor),
        ),
      ),
      duration: const Duration(milliseconds: 1300),
      // messageText: Text('Item removed'),
      backgroundColor: kBlack,
      icon: const AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          // child: CircularProgressIndicator(
          //   color: kWhite,
          // ),
        ),
      ),
      snackPosition: SnackPosition.TOP,
    );
