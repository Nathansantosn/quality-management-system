import 'package:assessment_software_senai/src/page/change_password/change_password_page.dart';
import 'package:assessment_software_senai/src/page/home/home_page.dart';
import 'package:assessment_software_senai/src/page/login/login_page.dart';
import 'package:assessment_software_senai/src/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final User user;

  const AppDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              (user.displayName != null) ? user.displayName! : '',
            ),
            accountEmail: Text(user.email!),
            decoration: BoxDecoration(color: Colors.blue[700]),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(user: user)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: const Text('Trocar senha'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordPage(user: user),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Deslogar'),
            onTap: () {
              AuthenticationService().unlog();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
