import 'package:flutter/material.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/main.dart';
import 'package:sportsapp/screens/authentication/forgot_password/forgot_password.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/screens/authentication/sign_up/sign_up.dart';
import 'package:sportsapp/screens/bookmarks/bookmarks.dart';
import 'package:sportsapp/screens/comments_page/comments_page.dart';
import 'package:sportsapp/screens/edit_profile/edit_profile.dart';
import 'package:sportsapp/screens/friends_page/friends_page.dart';
import 'package:sportsapp/screens/home/home.dart';
import 'package:sportsapp/screens/leagues/leagues.dart';
import 'package:sportsapp/screens/match_news_page/match_news_page.dart';
import 'package:sportsapp/screens/privacy_policy/privacy_policy.dart';
import 'package:sportsapp/screens/profile/profile.dart';
import 'package:sportsapp/screens/settings/settings.dart';
import 'package:sportsapp/screens/single_league_page/single_league_page.dart';
import 'package:sportsapp/screens/splash/splash_screen.dart';
import 'package:sportsapp/screens/videos/videos.dart';
import 'package:sportsapp/screens/welcome/welcome.dart';

//declare all named routes here

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  Base.routeName: (context) => const Base(),
  // AuthWrapper.routeName: (context) => const AuthWrapper(),
  SignIn.routeName: (context) => const SignIn(),
  SignUp.routeName: (context) => const SignUp(),
  News.routeName: (context) => News(
        scrollController: ScrollController(),
      ),
  LeagueScreen.routeName: (context) => const LeagueScreen(),
  Welcome.routeName: (context) => const Welcome(),
  ForgotPassword.routeName: (context) => const ForgotPassword(),
  FriendsPage.routeName: (context) => const FriendsPage(),
  EditProfile.routeName: (context) => const EditProfile(),
  Profile.routeName: (context) => const Profile(),
  SettingsPage.routeName: (context) => const SettingsPage(),
  CommentsPage.routeName: (context) => CommentsPage(),
  AuthWrapper.routeName: (context) => const AuthWrapper(),
  MatchNewsPage.routeName: (context) => const MatchNewsPage(),
  LeagueDetailsScreen.routeName: (context) => const LeagueDetailsScreen(),
  PrivacyPolicy.routeName: (context) => const PrivacyPolicy(),
  Bookmarks.routeName: (context) => const Bookmarks(),
  Videos.routeName: (context) => const Videos()
};
