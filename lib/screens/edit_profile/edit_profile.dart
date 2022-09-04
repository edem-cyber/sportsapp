import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/edit_profile/widgets/body.dart';

class EditProfile extends StatelessWidget {
  //routename
  static const routeName = '/edit-profile';
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvder = Provider.of<ThemeProvider>(context, listen: true);
    // var nagivate
    var navigationService = Provider.of<NavigationService>(context);

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            navigationService.goBack();
          },
          child: Text(
            "Cancel",
            // style: ,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: themeProvder.isDarkMode ? kWhite : kBlack),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              navigationService.goBack();
            },
            child: Text(
              "Save",
              // style: ,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: themeProvder.isDarkMode ? kWhite : kBlack),
            ),
          ),
        ],
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Edit Profile"),
      ),
      body: const Body(),
    );
  }
}
