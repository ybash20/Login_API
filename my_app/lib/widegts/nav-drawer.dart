// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_app/providors/auth.dart';
import 'package:my_app/screens/Posts.dart';
import 'package:my_app/screens/login-screen.dart';
import 'package:provider/provider.dart';

class Navdrawer extends StatelessWidget {
  const Navdrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          if (auth.authenticated) {
            return ListView(
              children: [
                ListTile(
                  // title: Text(auth.user.name),
                  title: Text(auth.user.name ?? 'Guest'),
                  subtitle: Text('By: Smart for tk'),
                ),
                ListTile(
                  title: Text('Posts'),
                  subtitle: Text('Click to view posts'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostsScreen()));
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  subtitle: Text('Click to Login'),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                ),
              ],
            );
          } else {
            return ListView(
              children: [
                ListTile(
                  title: Text('Login'),
                  subtitle: Text('Click to Login'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
                ListTile(
                  title: Text('Register'),
                  subtitle: Text('Click to Register'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
