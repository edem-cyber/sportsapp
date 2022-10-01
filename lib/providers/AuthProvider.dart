import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
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
  DatabaseService get databaseService => _databaseService;

  late final NavigationService _navigationService;
  late DeviceInfoPlugin _deviceInfo;
  //get device info
  // DeviceInfoPlugin get deviceInfo => _deviceInfo;

  Future getDeviceInfo() async {
    // final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      notifyListeners();
      return androidInfo.toMap().toString();
      // return androidInfo.;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      notifyListeners();
      return iosInfo.toMap().toString();
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await _deviceInfo.windowsInfo;
      notifyListeners();
      return windowsInfo.toMap().toString();
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await _deviceInfo.macOsInfo;
      return macOsInfo.toMap().toString();
    }
    return _deviceInfo;
  }

  // void loadInfo() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  //   if (kIsWeb) {
  //     WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
  //     // e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
  //     print('Web - Running on ${webBrowserInfo.userAgent}');
  //     // setState(() {text = webBrowserInfo.toMap().toString();});
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     print('iOS - Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
  //     // setState(() {text = iosInfo.toMap().toString();});
  //     // text = iosInfo.toMap().toString();
  //     notifyListeners();
  //   } else if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     print('Android - Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
  //     // setState(() {text = androidInfo.toMap().toString();});
  //   } else if (Platform.isWindows) {
  //     WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
  //     print(windowsInfo.toMap().toString());
  //     // setState(() {text = windowsInfo.toMap().toString();});
  //   } else if (Platform.isMacOS) {
  //     MacOsDeviceInfo macOSInfo = await deviceInfo.macOsInfo;
  //     print(macOSInfo.toMap().toString());
  //     // setState(() {text = macOSInfo.toMap().toString();});
  //   } else if (Platform.isLinux) {
  //     LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
  //     print(linuxInfo.toMap().toString());
  //     // setState(() {text = linuxInfo.toMap().toString();});
  //   }
  // }
  //posts list from firebase
  // get storageManager => _storageManager;

  //isLoading is used to show the loading indicator when signing in or out
  bool _isLoading = false;
  get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Stream<User?> get authState => _auth.idTokenChanges();

  // User? _user;
  User? get user => _auth.currentUser;

  GoogleSignIn? _googleSignIn;
  //google sign in accounnt
  GoogleSignInAccount? _googleSignInAccount;
  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;

  AuthProvider() {
    // posts = _databaseService.getFollowedTopics();
    _deviceInfo = DeviceInfoPlugin();

    // getDeviceInfo().then((value) {
    //   if (value != null) {
    //     _deviceInfo = value.toString();
    //     notifyListeners();
    //   }
    // });
    getDeviceInfo().then((value) {
      if (value != null) {
        var mystring = value.toString();
        //get
        print("DEVICE INFO HERE: $mystring");
      }
    });

    _auth = FirebaseAuth.instance;
    _databaseService = DatabaseService();
    _navigationService = NavigationService();
    _googleSignIn = GoogleSignIn();
    //get posts
    getPosts();

    authState.listen(
      (fireUser) {
        if (fireUser != null) {
          _databaseService.updateUserLastSeenTime(uid: fireUser.uid);
          print("UID IN LISTEN METHOD: $fireUser.uid");
          _databaseService.getUser(uid: fireUser.uid).then(
            (snapshot) {
              // * Check if the documentSnapshot exists or not.
              if (snapshot.exists) {
                final userData = snapshot.data() as Map<String, dynamic>?;
                //* Check if the document object is null or not
                if (userData != null) {}
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
      _navigationService.signInWithAnimation(Base.routeName);

      // debugPrint("PRINT DEVICE INFO : ${_deviceInfo.iosInfo}");
      // debugPrint("PRINT DEVICE INFO : ${_deviceInfo.androidInfo}");
      // debugPrint("PRINT DEVICE INFO : ${_deviceInfo.webBrowserInfo}");
      debugPrint("PRINT DEVICE INFO : ${_deviceInfo.windowsInfo}");
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

  // Future<bool> userExists(String username) async =>
  //     (await _instance
  //             .collection("users")
  //             .where("username", isEqualTo: username)
  //             .getDocuments())
  //         .documents
  //         .length >
  // 0;

  Future<void> signUp(
      String email, String password, String username, String photoURL) async {
    setIsLoading(true);

    try {
      //usercredential
      UserCredential usercredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (!await _databaseService.isDuplicateUniqueName(username: username)) {
        // UniqueName is duplicate
        // return 'Unique name already exists';

        var userInfoMap = {
          'email': email,
          'username': username,
          'password': password,
          'photoURL': photoURL,
          'lastSeen': DateTime.now(),
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          // 'userDeviceInfo': deviceInfo.iosInfo,
        };

        await _databaseService.addUserInfoToDB(
            uid: _auth.currentUser!.uid, userInfoMap: userInfoMap);
      } else {
        // UniqueName is duplicate
        // return 'Unique name already exists';
        appNotification(
          title: "Error",
          message: "User already exists",
          icon: const Icon(Icons.error, color: kWarning),
        );
      }

      if (!usercredential.isBlank!) {
        appNotification(
            title: "Success",
            message: "Signed Up",
            icon: const Icon(Icons.check, color: Colors.green));
        _navigationService.signInWithAnimation(Base.routeName);
      }
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
      setIsLoading(true);

      _googleSignInAccount = await _googleSignIn!.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await _googleSignInAccount?.authentication;

      var userInfoMap = {
        'email': _googleSignInAccount?.email,
        'username': _googleSignInAccount?.displayName,
        'password': _googleSignInAccount?.id,
        'photoURL': _googleSignInAccount?.photoUrl,
      };

      if (googleAuth != null) {
        UserCredential? usercredential = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );

        if (!await _databaseService.isDuplicateUniqueName(
            username: _googleSignInAccount?.displayName)) {
          // UniqueName is duplicate
          // return 'Unique name already exists';

          await _databaseService.addUserInfoToDB(
              uid: _auth.currentUser!.uid, userInfoMap: userInfoMap);
        } else {
          // UniqueName is duplicate
          // return 'Unique name already exists';
          // appNotification(
          //   title: "Error",
          //   message: "User already exists",
          //   icon: const Icon(Icons.error, color: kWarning),
          // );

          //UPDATE USER INFO
          await _databaseService.updateUser(
              uid: _auth.currentUser!.uid, userInfoMap: userInfoMap);
        }

        if (!usercredential.isBlank!) {
          appNotification(
              title: "Success",
              message: "Signed In",
              icon: const Icon(Icons.check, color: Colors.green));
          // _navigationService.signInWithAnimation(Base.routeName);
        }
      } else {
        appNotification(
          title: "Error",
          message: "Missing Google Auth Token",
          icon: const Icon(Icons.error, color: kWarning),
        );
        // setIsLoading(false);

        // _isLoading = false;
        // notifyListeners();
        // throw FirebaseAuthException(
        //   code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
        //   message: 'Missing Google Auth Token',
        // );
      }
    } catch (e) {
      print(e);
      debugPrint('Error login user into Firebase: $e');
    } finally {
      setIsLoading(false);
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
    // var apiKey = "37b3f6b92d2a4434a249e02fd8938841";
    // "https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=800dce9aa1334456ac941842fa55edf8");

    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?category=sports&q=football&language=en&apiKey=$apiKey");
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

  // likeUnlikePost(String posturl) {
  //   // _databaseService.likeUnlikePost(
  //   //     uid: _auth.currentUser!.uid, posturl: posturl);

  // }

  //bookmark post
  likePost(Article article) {
    _databaseService.likePost(uid: _auth.currentUser!.uid, article: article);
  }

  unlikePost(Article article) {
    _databaseService.unlikePost(uid: _auth.currentUser!.uid, article: article);
  }

  isLiked(Article article) {
    return _databaseService.isLiked(
        uid: _auth.currentUser!.uid, article: article);
  }

  // isPostLiked(String posturl) {
  //   return _databaseService.isPostLiked(_auth.currentUser!.uid, posturl);
  // }

  // likePost(String posturl) {
  //   _databaseService.likePost(posturl, _auth.currentUser!.uid);
  // }

  // unlikePost(String posturl) {
  //   _databaseService.unlikePost(posturl, _auth.currentUser!.uid);
  // }

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
