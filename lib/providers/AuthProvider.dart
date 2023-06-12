import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/models/PickReply.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/screens/authentication/sign_up/sign_up.dart';
import 'package:sportsapp/services/database_service.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/widgets/notification.dart';
import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
//import cloud functions
// import 'package:cloud_functions/cloud_functions.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    // posts = _databaseService.getFollowedTopics();
    _deviceInfo = DeviceInfoPlugin();

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
            (snapshot) async {
              // * Check if the documentSnapshot exists or not.
              if (snapshot.exists) {
                final userData = snapshot.data();
                //* Check if the document object is null or not
                if (userData != null) {
                  var isInFireStoreDoc = await checkUserDocument(fireUser.uid);
                  // _navigationService.signOutWithAnimation(SignIn.routeName);
                  if (isInFireStoreDoc != true) {
                    _navigationService.openFullScreenDialog(const SignUp());
                    appNotification(
                        title: "Sign Up",
                        message: "Please Sign Up Again",
                        icon: const Icon(Icons.abc));
                  }
                }
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
          //       // debugPrint('User data IS : ${_user!.email()}');
          //     } else {
          //       _navigationService.signOutWithAnimation(SignIn.routeName);
          //     }
          //   },
          // );
          // * In case the user is not null (exists), then the user must login
        }
      },
    );
  }

  // getPosts() {

  // }
  List<Article> news = [];

  //initialize shared preferences
  // FirebaseAuth _auth;
  late final FirebaseAuth _auth;

  //cloud function instance firestore
  // final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
  //   'addUser',
  // );
  // late StorageManager _storageManager;
  late final DatabaseService _databaseService;

  late DeviceInfoPlugin _deviceInfo;
  // Future<void> _onAuthStateChanged(User? firebaseUser) async {
  //   if (firebaseUser == null) {
  //     user = null;
  //     notifyListeners();
  //     return;
  //   }

  //   final email = firebaseUser.email;
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .where('email', isEqualTo: email)
  //       .get();
  //   if (querySnapshot.docs.isEmpty) {
  //     // The user doesn't exist in the Firestore Users collection
  //     // Redirect them to the sign-up page
  //     // ...
  //     // You can navigate to the sign-up page here
  //   } else {
  //     user = firebaseUser;
  //     notifyListeners();
  //   }
  // }

  // User? _user;

  GoogleSignIn? _googleSignIn;

  //google sign in accounnt
  GoogleSignInAccount? _googleSignInAccount;

  //isLoading is used to show the loading indicator when signing in or out
  bool _isLoading = false;

  late final NavigationService _navigationService;

  DatabaseService get databaseService => _databaseService;

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

  get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  User? get user => _auth.currentUser;

  Stream<User?> get authState => _auth.idTokenChanges();

  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;

  Future<bool> checkUserDocument(String uid) async {
    bool isExists = false;
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (docSnapshot.exists) {
        isExists = true;
      }
    } catch (e) {
      debugPrint('Error fetching user document: $e');
    }
    return isExists;
  }

  Future<void> signIn(String email, String password) async {
    //save user to storage
    setIsLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint('PRINT USER SIGN IN : ${_auth.currentUser}');
      // _navigationService.removeAndNavigateToRoute(Base.routeName);
      appNotification(
          title: "Success",
          message: "Signed In",
          icon: const Icon(Icons.check, color: Colors.green));
      _navigationService.signInWithAnimation(Base.routeName);
      //UPDATE LAST SEEN
      // _databaseService.updateUserLastSeenTime(uid: _auth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      var er = e.toString().replaceRange(0, 14, '').split(']')[1].trim();
      appNotification(
        title: "Error",
        message: er,
        icon: const Icon(Icons.error, color: kWarning),
      );
      debugPrint('Error login user into Firebase.');
    } catch (e) {
      appNotification(
        title: "Error",
        message: "Something went wrong",
        icon: const Icon(Icons.error, color: kWarning),
      );

      debugPrint('$e');
    } finally {
      setIsLoading(false);
    }
  }

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
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update user photo URL with Firebase
      await userCredential.user!.updatePhotoURL(photoURL);

      var userInfoMap = {
        'email': email,
        'username': '@$username',
        'displayName': displayName,
        'bio': '',
        'password': password,
        'photoURL': photoURL ?? '',
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
        'liked_posts': [],
        'isAdmin': false,
      };

      // Add user info to the database
      await _databaseService.addUserInfoToDB(
          uid: _auth.currentUser!.uid, userInfoMap: userInfoMap);

      // Save user to storage
      if (!userCredential.isBlank!) {
        appNotification(
          title: "Success",
          message: "Signed Up",
          icon: const Icon(Icons.check, color: Colors.green),
        );
        _navigationService.signInWithAnimation(Base.routeName);
      }
    } catch (e) {
      // Handle error
      var er = e.toString().replaceRange(0, 14, '').split(']')[1].trim();
      appNotification(
        title: "Error",
        message: er,
        icon: const Icon(Icons.error, color: kWarning),
      );
    } finally {
      setIsLoading(false);
    }
  }

  String generateRandomUsername() {
    List<String> adjectives = [
      'happy',
      'sunny',
      'playful',
      'creative',
      'vibrant',
      'daring',
      'brilliant',
      'charming',
      'elegant',
      'fantastic',
      'cyber',
      'gentle',
      'quirky',
      'sparkling',
      'talented',
      'witty',
      'amazing',
      'blissful',
      'cool',
      'dynamic',
      'enchanting',
      'fearless',
      'graceful',
      'joyful',
      'kind',
      'lively',
      'magical',
      'noble',
      'optimistic',
      'peaceful',
      'radiant'
    ];

    List<String> safeWords = [
      'apple',
      'banana',
      'carrot',
      'dolphin',
      'elephant',
      'flower',
      'guitar',
      'honey',
      'island',
      'jungle',
      'koala',
      'lemon',
      'mountain',
      'mango',
      'ocean',
      'cheese',
      'penguin',
      'ruby',
      'quartz',
      'rainbow',
      'sunshine',
      'tiger',
      'umbrella',
      'rainbow',
      'soup',
      'seed',
      'volcano',
      'watermelon',
      'xylophone',
      'yoga',
      'zebra'
    ];

    Random random = Random();
    String adjective = adjectives[random.nextInt(adjectives.length)];
    String safeWord = safeWords[random.nextInt(safeWords.length)];
    String number = (random.nextInt(900) + 001)
        .toString(); // Generates a random 3-digit number (100-999)
    return '@$adjective$safeWord$number';
  }

  Future<void> signInWithGoogle() async {
    try {
      setIsLoading(true);

      _googleSignInAccount = await _googleSignIn!.signIn();
      // var userNameWithAt = _googleSignInAccount!.email.split('@')[0];

      // Generate a random username
      var randomUsername =
          generateRandomUsername(); // Assuming you have the generateRandomUsername function implemented

      final GoogleSignInAuthentication? googleAuth =
          await _googleSignInAccount?.authentication;

      var userInfoMap = {
        'email': _googleSignInAccount?.email,
        'username':
            randomUsername, // Use the random username instead of userNameWithAt
        'displayName': _googleSignInAccount?.displayName,
        'bio': '',
        'password': _googleSignInAccount?.id,
        'photoURL': _googleSignInAccount?.photoUrl,
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
        'liked_posts': [],
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
      }
    } catch (e) {
      debugPrint("$e");
      debugPrint('Error login user into Firebase: $e');
    } finally {
      setIsLoading(false);
      debugPrint('Sign up debugPrint ${_auth.currentUser}');
    }
  }

  Future<void> signInAnonymously() async {
    try {
      setIsLoading(true);
      UserCredential userCredential = await _auth.signInAnonymously();

      // Generate a random username
      var randomUsername = generateRandomUsername();

      var userInfoMap = {
        'email': '',
        'username': randomUsername,
        'displayName': '',
        'bio': '',
        'password': '',
        'photoURL': '',
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
        'liked_posts': [],
        'isAdmin': false,
      };

      await _databaseService.addUserInfoToDB(
        uid: userCredential.user!.uid,
        userInfoMap: userInfoMap,
      );

      if (!userCredential.isBlank!) {
        appNotification(
          title: "Success",
          message: "Signed In Anonymously",
          icon: const Icon(Icons.check, color: Colors.green),
        );
        _navigationService.signInWithAnimation(Base.routeName);
      }
    } catch (e) {
      var er = e.toString().replaceRange(0, 14, '').split(']')[1].trim();
      appNotification(
        title: "Error",
        message: er,
        icon: const Icon(Icons.error, color: kWarning),
      );
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> appleSign() async {
    setIsLoading(true);

    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // Generate a random username
      var randomUsername = generateRandomUsername();

      var userInfoMap = {
        'email': appleCredential.email ?? '',
        'username': randomUsername,
        'displayName': '', // Add the display name obtained from Apple Sign-In
        'bio': '',
        'password':
            '', // Apple Sign-In doesn't provide a password, so leave it blank
        'photoURL': '', // Add the photo URL obtained from Apple Sign-In
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
        'liked_posts': [],
        'isAdmin': false,
      };

      // Add user info to the database
      await _databaseService.addUserInfoToDB(
          uid: userCredential.user!.uid, userInfoMap: userInfoMap);

      // Save user to storage
      appNotification(
        title: "Success",
        message: "Signed Up",
        icon: const Icon(Icons.check, color: Colors.green),
      );
      _navigationService.signInWithAnimation(Base.routeName);
    } catch (e) {
      // Handle error
      // var er = e.toString().replaceRange(0, 14, '').split(']')[1].trim();
      print(e);
      appNotification(
        title: "Error",
        message: e.toString(),
        icon: const Icon(Icons.error, color: kWarning),
      );
    } finally {
      setIsLoading(false);
    }
  }

  // String generateNonce() {
  //   // Generate a random nonce string
  //   // Replace this implementation with your own nonce generation logic
  //   return 'random_nonce';
  // }

  String sha256ofString(String input) {
    var bytes = utf8.encode(input); // Convert the input string to bytes
    var digest = sha256.convert(bytes); // Calculate the SHA-256 hash
    return digest.toString();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn?.signOut();
    await _googleSignIn?.signOut();
    _auth.signOut();
    //set local user to null;
    // _user = null;
    _navigationService.signOutWithAnimation(SignIn.routeName);
  }

  Future<List<Article>> getPosts() async {
    var apiKey = "800dce9aa1334456ac941842fa55edf8";
    // var apiKey = "37b3f6b92d2a4434a249e02fd8938841";
    // "https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=800dce9aa1334456ac941842fa55edf8");

    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?category=sports&q=football&language=en&apiKey=$apiKey");

    try {
      var response = await http.get(url);
      // debugPrint("RESPONSE STATUS: ${response.statusCode}");
      // debugPrint("RESPONSE BODY: ${response.body}");

      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach(
          (element) {
            if (element['urlToImage'] != null &&
                element['description'] != null) {
              Article article = Article(
                title: element['title'] ?? "",
                description: element['description'] ?? "",
                urlToImage: element['urlToImage'] ?? "",
                content: element['content'] ?? "",
                publishedAt: DateTime.parse(element['publishedAt']),
                author: element['author'] ?? "",
                articleUrl: element['url'] ?? "",
              );
              // debugPrint("ARTICLE: ${article.title}");
              // debugPrint("NEWS LENGTH: ${news.length}");
              news.add(article);
            }
          },
        );
      }
    } catch (e) {
      debugPrint("GETPOSTS ERROR: $e");
    }
    // debugPrint("JSON DATA: ${jsonData}");
    // debugPrint("JSON STATUS: ${jsonData['status']}");
    // debugPrint(news);
    return news;
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await _databaseService.updateDisplayName(
          displayName, _auth.currentUser!.uid);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateBio(String bio) async {
    try {
      await _databaseService.updateBio(bio, _auth.currentUser!.uid);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      await _auth.currentUser!.updatePhotoURL(photoUrl);
      await _databaseService.updatePhotoUrl(photoUrl, _auth.currentUser!.uid);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
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

  Future<DocumentSnapshot<Map<String, dynamic>>> getProfileData(
      {required String id}) async {
    return await _databaseService.getUser(uid: id);
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
        var m = value.data() ?? {};
        if (m['isAdmin'] == true) {
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

  // get chat messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      {required String chatId}) {
    return _databaseService.getChatMessages(chatId: chatId);
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

  Future<void> createChat(
      {required String recipientId,
      required Map<String, dynamic> message}) async {
    _databaseService.createChat(
      user1: _auth.currentUser!.uid,
      user2: recipientId,
      message: message,
    );
  }

  Stream<QuerySnapshot> getSingleChatStream({
    required String user1,
    required String user2,
  }) {
    return _databaseService.getSingleChatStream(
      user1: user1,
      user2: user2,
    );
  }

  // get friend requests
  Future<List<String>> getFriendRequests() {
    return _databaseService.getFriendRequests(
      userId: _auth.currentUser!.uid,
    );
  }

  // get friend requests
  Future<List<String>> getFriends() {
    return _databaseService.getFriends(
      userId: _auth.currentUser!.uid,
    );
  }

  //add reply based on uid
  addPickReply(PickReply reply, String pickId) {
    _databaseService.addPickReply(reply, pickId);
  }

  sendFriendRequest(String uid) {
    _databaseService.sendFriendRequest(
      receiverId: uid,
      senderId: _auth.currentUser!.uid,
    );
  }

  acceptFriendRequest(String uid) {
    _databaseService.acceptFriendRequest(
      receiverId: _auth.currentUser!.uid,
      senderId: uid,
    );
  }

  cancelFriendRequest(String uid) {
    _databaseService.cancelFriendRequest(
      receiverId: _auth.currentUser!.uid,
      senderId: uid,
    );
  }

  removeFriend(String uid) {
    _databaseService.removeFriend(
      userId: _auth.currentUser!.uid,
      friendId: uid,
    );
  }

  Future<String> checkIfFriends(String uid) {
    return _databaseService.checkIfFriends(
        friendId: uid, userId: _auth.currentUser!.uid);
  }

  Future<String> getFriendStatus(String uid) {
    return _databaseService.getFriendStatus(
        friendId: uid, userId: _auth.currentUser!.uid);
  }

  Stream<String> getFriendStatusStream(String uid) {
    return _databaseService.getFriendStatusStream(
        friendId: uid, userId: _auth.currentUser!.uid);
  }

  // searchUsers

  Future<List<Map<String, dynamic>>> searchUsers(String searchTerm) async {
    return await _databaseService.searchUsers(searchTerm);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchPicks(
      {String? searchTerm}) {
    return _databaseService.searchPicks(searchTerm: searchTerm);
  }

// getChatsForUser
  Stream<QuerySnapshot> getChatsForUser({required String uid}) {
    return _databaseService.getChatsForUser(uid: uid);
  }

  Future<DocumentSnapshot> getLastMessageForChat(
      {required String chatId}) async {
    return await _databaseService.getLastMessageForChat(chatId: chatId);
  }

  void createRoom({required String roomTitle, required String roomDesc}) {}
}
