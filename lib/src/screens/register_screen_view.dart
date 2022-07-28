import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterScreenView extends StatelessWidget {
  RegisterScreenView({Key? key}) : super(key: key);

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          debugPrint("username: ${_userNameController.text}");
                          debugPrint("password: ${_passwordController.text}");

                          registerWithEmailAndPassword(_userNameController.text,
                                  _passwordController.text)
                              .then((value) => print(value.user!.uid));
                        },
                        child: Text('Register')))
              ],
            )),
          )
        ],
      ),
    );
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String emailFromTheBody, String passwordFromTheBody) async {
    UserCredential? _userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailFromTheBody, password: passwordFromTheBody);
    if (_userCredential == null) {
      debugPrint('null');
    }

    debugPrint(_userCredential.user!.email.toString());
    return _userCredential;

// try {
//   final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//     email: emailAddress,
//     password: password,
//   );
// } on FirebaseAuthException catch (e) {
//   if (e.code == 'weak-password') {
//     print('The password provided is too weak.');
//   } else if (e.code == 'email-already-in-use') {
//     print('The account already exists for that email.');
//   }
// } catch (e) {
//   print(e);
// }
  }
}
