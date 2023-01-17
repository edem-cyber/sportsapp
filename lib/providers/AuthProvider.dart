import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/models/Reply.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/screens/picks/picks.dart';
import 'package:sportsapp/services/database_service.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/widgets/notification.dart';
import 'package:http/http.dart' as http;
//import cloud functions
import 'package:cloud_functions/cloud_functions.dart';

class AuthProvider with ChangeNotifier {
  //initialize shared preferences
  // FirebaseAuth _auth;
  late final FirebaseAuth _auth;
  //cloud function instance firestore
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    'addUser',
  );
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
    // getDeviceInfo().then((value) {
    //   if (value != null) {
    //     var mystring = value.toString();
    //     //get
    //     debugPrint("DEVICE INFO HERE: $mystring");
    //   }
    // });

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
          // debugPrint("UID IN LISTEN METHOD: $fireUser.uid");
          _databaseService.getUser(uid: fireUser.uid).then(
            (snapshot) {
              // * Check if the documentSnapshot exists or not.
              if (snapshot.exists) {
                final userData = snapshot.data() as Map<String, dynamic>?;
                //* Check if the document object is null or not
                if (userData != null) {}
              }
              //* Automatic navigates to the home page
              // _navigationService.signInWithAnimation(Base.routeName);
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

  Future<bool> checkDuplicate(String username) async {
    bool result = await _databaseService.isDuplicateUsername("@$username");
    if (result == true) {
      appNotification(
        title: "Error",
        message: "Username already taken",
        icon: const Icon(
          Icons.error,
          color: kWarning,
        ),
      );
    }
    return result;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
    String? photoURL,
  }) async {
    setIsLoading(true);

    try {
      var userNameWithAt = '@$username';
      bool isDuplicateUsername =
          await _databaseService.isDuplicateUsername(userNameWithAt);

      //usercredential
      UserCredential usercredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      //update user photo with firebase
      await usercredential.user!.updatePhotoURL(photoURL);

      var userInfoMap = {
        'email': email,
        'username': userNameWithAt,
        'displayName': displayName,
        'bio': '',
        'password': password,
        'photoURL': photoURL ?? '',
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
        'likes': [],
        'isAdmin': false,
      };
      await _databaseService.addUserInfoToDB(
          uid: _auth.currentUser!.uid, userInfoMap: userInfoMap);

      //save user to storage
      if (!usercredential.isBlank!) {
        appNotification(
            title: "Success",
            message: "Signed Up",
            icon: const Icon(Icons.check, color: Colors.green));
        _navigationService.signInWithAnimation(Base.routeName);
      }

      setIsLoading(false);

      _navigationService.signInWithAnimation(Base.routeName);

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

      //CHECK duplicate usernames
      // if (e.code == 'username-already-in-use') {

      setIsLoading(false);
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      setIsLoading(true);

      //check if username is duplicate
      // if (!await _databaseService.isDuplicateUniqueName(username: username)) {

      _googleSignInAccount = await _googleSignIn!.signIn();
      var userNameWithAt = _googleSignInAccount!.email.split('@')[0];

      final GoogleSignInAuthentication? googleAuth =
          await _googleSignInAccount?.authentication;

      // if (await _databaseService.isDuplicateUniqueName(
      //     username: "@${_googleSignInAccount!.email.split('@')[0]}")) {
      //   appNotification(
      //     title: "Error",
      //     message: "User already exists",
      //     icon: const Icon(Icons.error, color: kWarning),
      //   );
      // setIsLoading(false);
      // return;
      // } else {

      var userInfoMap = {
        'email': _googleSignInAccount?.email,
        'username': "@${_googleSignInAccount!.email.split('@')[0]}",
        'displayName': _googleSignInAccount?.displayName,
        'bio': '',
        'password': _googleSignInAccount?.id,
        'photoURL': _googleSignInAccount?.photoUrl,
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
        'likes': [],
        'isAdmin': false,
      };

      if (googleAuth != null) {
        UserCredential? usercredential = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ),
        );

        await _databaseService.addUserInfoToDB(
            uid: _auth.currentUser!.uid, userInfoMap: userInfoMap);

        if (!usercredential.isBlank!) {
          appNotification(
              title: "Success",
              message: "Signed In",
              icon: const Icon(Icons.check, color: Colors.green));
          _navigationService.signInWithAnimation(Base.routeName);
        }
      } else {
        appNotification(
          title: "Error",
          message: "Missing Google Auth Token",
          icon: const Icon(Icons.error, color: kWarning),
        );
        // }
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
    // print("RESPONSE STATUS: ${response.statusCode}");
    // print("RESPONSE BODY: ${response.body}");

    var jsonData = jsonDecode(response.body);
    // print("JSON DATA: ${jsonData}");
    // print("JSON STATUS: ${jsonData['status']}");
    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach(
        (element) {
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
        },
      );
    }
    return news;
  }

  updateUser({String? displayName, String? bio, String? photoUrl}) {
    _auth.currentUser!.updateProfile(
      displayName: displayName,
      photoURL: photoUrl,
    );
    _databaseService.updateUser(
        displayName: displayName, bio: bio, photoUrl: photoUrl, uid: user!.uid);

    if (photoUrl != null) {
      user!.updatePhotoURL(photoUrl);
    }
    if (displayName != null) {
      user!.updateDisplayName(displayName);
    }

    notifyListeners();
  }

  likePost(Article article) {
    _databaseService.likePost(
      article: article,
      uid: _auth.currentUser!.uid,
    );
  }
  // Future<bool> toggleLikedPost(Article article) async {
  //   return await _databaseService.toggleLikedPost(
  //     article: article,
  //     uid: _auth.currentUser!.uid,
  //   );
  // }

  unlikePost(Article article) {
    _databaseService.unlikePost(uid: _auth.currentUser!.uid, article: article);
  }

  removeFromDb(String articleUrl) {
    return _databaseService.removeFromDb(
        uid: _auth.currentUser!.uid, postUrl: articleUrl);
  }

  Future<bool> isPostInLikedArray(Article article) async {
    return _databaseService.isPostInLikedArray(
        uid: _auth.currentUser!.uid, article: article);
  }

  Future<List<String>> getLikedPostsArray() async {
    List<String> list = await _databaseService.getLikedPostsArray(
      uid: _auth.currentUser!.uid,
    );
    return list;
  }

  Future<bool> isLiked(Article article) {
    return _databaseService.isPostInLikedArray(
        uid: _auth.currentUser!.uid, article: article);
  }

  //future function to get user data from firebase
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return await _databaseService.getUser(uid: _auth.currentUser!.uid);
  }

  // Future createPick() async {
  //   //if user is not admin
  //   var isAdminUser = false;
  //   getUserData().then(
  //     (value) {
  //       if (value.data()!['isAdmin'] == true) {
  //         isAdminUser = true;
  //       }
  //     },
  //   );

  //   return _databaseService.createPick();
  // }

  Future<bool> isAdmin() async {
    var isAdminUser = false;
    await getUserData().then(
      (value) {
        if (value.data()!['isAdmin'] == true) {
          isAdminUser = true;
        }
      },
    );
    return isAdminUser;
  }

  Future<void> createPick({required String title, required String desc}) async {
    //if user is not admin
    // var isAdminUser = false;
    isAdmin().then(
      (value) {
        if (value == true) {
          // isAdminUser = true;
          _databaseService.createPick(title: title, desc: desc);
        }
      },
    );
  }

  Future<void> deletePick({required String id}) async {
    //if user is not admin
    // var isAdminUser = false;
    _databaseService.deletePick(id: id);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPicks() {
    return _databaseService.getAllPicks();
  }

  sendMessage(
    String message,
  ) {
    _databaseService.sendPost(
      message: message,
      id: Timestamp.now().toString(),
      photoURL: _auth.currentUser!.photoURL ?? "",
    );
  }

  //add reply based on uid
  addReply(Reply reply, String pickId) {
    _databaseService.addReply(reply, pickId);
  }

  Future<List<Reply>> getRepliesFromSingleDoc(String pickId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Picks')
        .doc(pickId)
        .collection('replies')
        .get();

    List<Reply> replies = [];
    for (var doc in snapshot.docs) {
      //convert to map string dynamic
      // var data = doc.data();

      replies.add(
        Reply.fromJson(doc.data() as Map<String, dynamic>),
      );
    }
    return replies;
  }

  Future<Map<String, dynamic>?> getSinglePick({
    required String id,
  }) {
    return _databaseService.getSinglePick(id: id);
  }

  // isPostLiked(String posturl) {
  //   return _databaseService.isPostLiked(_auth.currentUser!.uid, posturl);
  // }

  // unlikePost(String posturl) {
  //   _databaseService.unlikePost(posturl, _auth.currentUser!.uid);
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
