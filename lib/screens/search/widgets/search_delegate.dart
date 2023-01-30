import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';

class UserSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    Future<List<Map<String, dynamic>>> users = authProvider.searchUsers(query);
    return FutureBuilder(
      future: users,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userData = snapshot.data![index];
              return ListTile(
                title: Text(userData['displayName']),
                subtitle: Text(userData['email']),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
