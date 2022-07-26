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
            //to get data using future builder
            // getDataUsingFutureBuilder(),

            Container(
              height: 500,
              padding: EdgeInsets.all(20),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firebaseFirestore.collection('names').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('err ${snapshot.error}');
                    } else if (snapshot.data == null) {
                      return Text('no Data');
                    }
                    snapshot.data!.docs.first;

                    return ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data!.docs[index]
                                .data()["first_name"]
                                .toString()),
                            IconButton(
                                onPressed: () {
                                  _firebaseFirestore
                                      .collection('names')
                                      .where("first_name",
                                          isEqualTo: snapshot.data!.docs[index]
                                              .data()["first_name"])
                                      .get()
                                      .then((value) =>
                                          value.docs.first.reference.delete());
                                },
                                icon: Icon(Icons.delete))
                          ],
                        );
                      },
                    );

                    // return Text(snapshot.data!.docs.first
                    //     .data()["first_name"]
                    //     .toString());
                  }),
            ),

            // readOneDocumentWidget(),
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

  Future<QuerySnapshot<Map<String, dynamic>>> getDataOnceUsingFuture() async {
    return await _firebaseFirestore.collection('names').get();
  }

  Widget getDataUsingFutureBuilder() {
    return Column(
      children: [
        Text('read the entire collection documents once'),
        Container(
          height: 350,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: getDataOnceUsingFuture(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.data == null) {
                  return Text('no data');
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Text(snapshot.data!.docs[index]
                          .data()["first_name"]
                          .toString());
                    });
              }),
        ),
      ],
    );
  }

  Widget readOneDocumentWidget() {
    return Column(
      children: [
        Text('read one specific document'),
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
      ],
    );
  }
}
