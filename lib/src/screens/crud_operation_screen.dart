import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CrudOperationsScreen extends StatelessWidget {
  CrudOperationsScreen({Key? key}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: FutureBuilder<DocumentSnapshot>(
                  future: readTheSingleDocument(),
                  builder: (envan, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.data == null || !snapshot.hasData) {
                      return Text('empty');
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    Map<String, dynamic> name =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return Text(name.values.first);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'required';
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() == true) {
                    debugPrint('form validated');
                    await addANameToTheDB(name: _nameController.text)
                        .then((value) => print(value.path));
                  } else {
                    debugPrint('form not validated');
                  }
                },
                child: Text('Add Data'))
          ],
        )),
      ),
    );
  }

  Future<DocumentReference> addANameToTheDB({required String name}) async {
    DocumentReference _doc = await _firebaseFirestore.collection('names').add({
      "first_name": "$name",
    });
    return _doc;
  }

  Future<DocumentSnapshot> readTheSingleDocument() async {
    DocumentSnapshot _doc =
        await _firebaseFirestore.doc("names/QXAKIZJQeG46rCfbczBQ").get();
    print(_doc.data());
    return _doc;
  }
}
