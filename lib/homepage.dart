import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addfavor.dart';
import 'package:favor/loginpage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.userId, this.onSignedOut, this.auth})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          Expanded(child: Text("Favor")),
          FlatButton(
            child: Text(
              "Log out",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onSignedOut,
          )
        ],
      )),
      body: StreamBuilder(
          stream: Firestore.instance.collection('favor').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent: 55.0,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data.documents[index];
                  return Dismissible(
                    background: Container(color: Colors.red),
                    key: Key('dismissible'),
                    child: ListTile(
                        key: ValueKey(document.documentID),
                        title: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0x80000000)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    "${document['Ower']} to ${document['Receiver']}"),
                              ),
                              Text(
                                document['Favor'],
                              ),
                            ],
                          ),
                        )),
                    onDismissed: (dir) =>
                        Firestore.instance.runTransaction((transaction) async {
                          await Firestore.instance
                              .collection('favor')
                              .document(document.documentID)
                              .delete();
                        }),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddFavor()));
          },
          tooltip: "Create a Favor",
          child: Icon(Icons.add)),
    );
  }
}
