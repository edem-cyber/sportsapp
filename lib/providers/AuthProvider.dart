import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/services/database_service.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/widgets/notification.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  //initialize shared preferences
  // FirebaseAuth _auth;
  late final FirebaseAuth _auth;
  // late StorageManager _storageManager;
  late final DatabaseService _databaseService;
  late final NavigationService _navigationService;
  //posts list from firebase
  // get storageManager => _storageManager;

  //isLoading is used to show the loading indicator when signing in or out
  bool _isLoading = false;
  get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // UserModel? _userFromFirebase(User? user) {
  //   return user != null
  //       ? UserModel(
  //           uid: user.uid,
  //           email: user.email!,
  //           // name: user.name!,
  //           photoURL: user.photoURL ?? AppImage.defaultProfilePicture,
  //           username: user.displayName ?? user.email!.split('@')[0],
  //         )
  //       : null;
  // }
  Stream<User?> get authState => _auth.idTokenChanges();

  // User? _user;
  User? get user => _auth.currentUser;

  GoogleSignIn? _googleSignIn;
  //google sign in accounnt
  GoogleSignInAccount? _googleSignInAccount;
  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;

  AuthProvider() {
    // posts = _databaseService.getFollowedTopics();
    _auth = FirebaseAuth.instance;
    _databaseService = DatabaseService();
    _navigationService = NavigationService();
    _googleSignIn = GoogleSignIn();
    //get posts
    getPosts();

    authState.listen(
      (fireUser) {
        if (fireUser != null) {
          _databaseService.updateUserLastSeenTime(fireUser.uid);
          _databaseService.getUser(fireUser.uid).then(
            (snapshot) {
              // * Check if the documentSnapshot exists or not.
              if (snapshot.exists) {
                final userData = snapshot.data() as Map<String, dynamic>?;
                //* Check if the document object is null or not
                if (userData != null) {
                  // user = UserModel.fromMap(userData);
                  // _userFromFirebase = user;
                  // _userFromFirebase(_user);
                  // print(_user);
                  // print('User data IS : ${user!.toJson()}');
                }
              }
              //* Automatic navigates to the home page
              _navigationService.signInWithAnimation(Base.routeName);
            },
          );
        } else {
          //read user from storage
          // _storageManager.readData("user").then(
          //   (user) {
          //     if (user != null) {
          //       _user = user;
          //       // print('User data IS : ${_user!.email()}');
          //     } else {
          //       _navigationService.signOutWithAnimation(SignIn.routeName);
          //     }
          //   },
          // );
          // * In case the user is not null (exists), then the user must login
          // _navigationService.signOutWithAnimation(SignIn.routeName);
        }
      },
    );
  }

  Future<void> signIn(String email, String password) async {
    //save user to storage
    setIsLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint('PRINT USER SIGN IN : ${_auth.currentUser}');
      // _navigationService.removeAndNavigateToRoute(Base.routeName);
      //save user to storage
      // await _storageManager.saveData("user", _auth.currentUser!.email);

      // ignore: await_only_futures
      await appNotification(
          title: "Success",
          message: "Signed In",
          icon: const Icon(Icons.check, color: Colors.green));
      // _navigationService.signInWithAnimation(Base.routeName);
    } on FirebaseAuthException catch (e) {
      var er = e.toString().replaceRange(0, 14, '').split(']')[1].trim();
      appNotification(
        title: "Error",
        message: er,
        icon: const Icon(Icons.error, color: kWarning),
      );
      setIsLoading(false);
      debugPrint('Error login user into Firebase.');
    } catch (e) {
      appNotification(
        title: "Error",
        message: "Something went wrong",
        icon: const Icon(Icons.error, color: kWarning),
      );
      setIsLoading(false);
      debugPrint('$e');
    } finally {
      setIsLoading(false);
    }
  }

  Future<User?> signUp(
      String email, String password, String username, String photoURL) async {
    setIsLoading(true);

    try {
      UserCredential usercredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      var userInfoMap = {
        'email': email,
        'username': username,
        'password': password,
        'photoURL': photoURL,
      };

      await _databaseService.addUserInfoToDB(
          _auth.currentUser!.uid, userInfoMap);
      //database service to create a new user
      // await _databaseService.createUser(
      //   email: email,
      //   name: username,
      //   uid: _auth.currentUser!.uid,
      //   // photoURL: _auth.currentUser!.photoURL!,
      // );
      setIsLoading(false);
      // _navigationService.signInWithAnimation(Base.routeName);

      // return _userFromFirebase(_auth.currentUser);
    } catch (e) {
      //switch
      //regex to filter firebase error messages
      var er = e.toString().replaceRange(0, 14, '').split(']')[1].trim();
      appNotification(
        title: "Error",
        message: er,
        icon: const Icon(Icons.error, color: kWarning),
      );
      setIsLoading(false);
    } finally {
      setIsLoading(false);
    }
    print('Sign up print ${_auth.currentUser}');
    // return _userFromFirebase(_auth.currentUser);
  }

  Future<User?> signInWithGoogle() async {
    try {
      // setIsLoading(true);
      _isLoading = true;
      notifyListeners();
      _googleSignInAccount = await _googleSignIn!.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await _googleSignInAccount?.authentication;

      if (googleAuth != null) {
        UserCredential? credentials = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );
        var userInfoMap = {
          'email': _googleSignInAccount?.email,
          'username': _googleSignInAccount?.displayName,
          'password': _googleSignInAccount?.id,
          'photoURL': _googleSignInAccount?.photoUrl,
        };
        //if user already exists in database, then update the user info
        await _databaseService.addUserInfoToDB(
            _auth.currentUser!.uid, userInfoMap);

        await _databaseService.addUserInfoToDB(
            _auth.currentUser!.uid, userInfoMap);
        final User? user = credentials.user;
        _isLoading = false;
        notifyListeners();
        // return _userFromFirebase(user);
      } else {
        appNotification(
          title: "Error",
          message: "Missing Google Auth Token",
          icon: const Icon(Icons.error, color: kWarning),
        );
        setIsLoading(false);

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
        icon: const Icon(Icons.error, color: kWarning),
      );
      setIsLoading(false);
      // _isLoading = false;
      // notifyListeners();
      // return _userFromFirebase(_auth.currentUser);
    } finally {
      print('Sign up print ${_auth.currentUser}');
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

  // Future<void> signOut() async {
  //   try {
  //     _googleSignIn?.signOut().then((value) => _auth.signOut().then((value) =>
  //         _navigationService.signOutWithAnimation(SignIn.routeName)));

  //     //clear cache
  //     await _auth.currentUser?.delete();

  //     // _googleSignIn?.signOut();

  //     //if sign out is success show notification
  //     appNotification(
  //         title: "Success",
  //         message: "Signed Out",
  //         icon: const Icon(Icons.check, color: Colors.green));
  //     notifyListeners();
  //     return;
  //   } catch (e) {
  //     debugPrint("SIGN OUT ERROR: $e");
  //     return;
  //   } finally {
  //     notifyListeners();
  //     // setIsLoading(false);
  //   }
  // }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn?.signOut();
    _auth.signOut();
    //set local user to null;
    // _user = null;
    _navigationService.signOutWithAnimation(SignIn.routeName);
  }

  // getPosts() {

  // }
  List<Article> news = [];

  Future<List<Article>> getPosts() async {
    var apiKey = "800dce9aa1334456ac941842fa55edf8";
    // "https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=800dce9aa1334456ac941842fa55edf8");

    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=800dce9aa1334456ac941842fa55edf8");
    var response = await http.get(url);
    print("RESPONSE STATUS: ${response.statusCode}");
    // print("RESPONSE BODY: ${response.body}");

    var jsonData = jsonDecode(response.body);
    // print("JSON DATA: ${jsonData}");
    print("JSON STATUS: ${jsonData['status']}");
    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element['title'] ?? "",
            description: element['description'] ?? "",
            urlToImage: element['urlToImage'] ?? "",
            content: element['content'] ?? "",
            publishedAt: DateTime.parse(element['publishedAt']),
            author: element['author'] ?? "",
            articleUrl: element['url'] ?? "",
          );
          // print("ARTICLE: ${article.title}");
          // print("NEWS LENGTH: ${news.length}");
          news.add(article);
        }
      });
    }
    return news;
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
