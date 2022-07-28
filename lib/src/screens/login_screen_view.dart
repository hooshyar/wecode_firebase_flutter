import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wecode_firebase_flutter/src/screens/register_screen_view.dart';

class LoginScreenView extends StatelessWidget {
  LoginScreenView({Key? key}) : super(key: key);
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('loading...'),
            );
          } else if (snapshot.hasError) {
            return Text('error: ${snapshot.error}');
          } else if (snapshot.data == null) {
            return notLoggedIn(context);
          }
          return theUserIsLoggedIn(snapshot.data!.email!);
        });
  }

  Future<UserCredential> loginWithUserAndPassword(
      {required String email, required String password}) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Widget notLoggedIn(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Text('Welcome'),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            child: Form(
                child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('user name/email'),
                TextFormField(
                  controller: _userNameController,
                ),
                SizedBox(
                  height: 35,
                ),
                Text('password'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterScreenView()));
                    },
                    child: Text('not registered yet? register here!')),
                SizedBox(
                  height: 25,
                ),
                Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () async {
                          debugPrint("username: ${_userNameController.text}");
                          debugPrint("password: ${_passwordController.text}");

                          await loginWithUserAndPassword(
                                  email: _userNameController.text,
                                  password: _passwordController.text)
                              .then((value) => print(value.user!.email));
                        },
                        child: Text('login')))
              ],
            )),
          )
        ],
      ),
    );
  }

  Widget theUserIsLoggedIn(String email) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello dear $email'),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('logout')),
          ],
        ),
      ),
    );
  }
}
