import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Favor',
        home: const MyHomePage(title: 'Favor'),
        theme: new ThemeData(primarySwatch: Colors.deepOrange));
  }
}

class AddFavor extends StatefulWidget {
  @override
  AddFavorState createState() {
    return new AddFavorState();
  }
}

class AddFavorState extends State<AddFavor> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String favor, ower, receiver;

  String _isValid(String val) {
    return val.isEmpty ? 'Name is required' : null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Submit a Favor")),
        body: new Container(
            padding: new EdgeInsets.all(20.0),
            child: Form(
                autovalidate: true,
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    new TextFormField(
                        validator: _isValid,
                        onSaved: (fav) => favor = fav,
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration(labelText: "Favor Name")),
                    new TextFormField(
                        validator: _isValid,
                        onSaved: (owe) => ower = owe,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            labelText: "Ower of the Favor")),
                    new TextFormField(
                        validator: _isValid,
                        onSaved: (rec) => receiver = rec,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            labelText: "Reciever of the Favor")),
                    new Container(
                      child: new RaisedButton(
                        child: new Text(
                          'Add',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState.save();
                          Firestore.instance.collection('favor').add({
                            "Favor": favor,
                            "Ower": ower,
                            "Receiver": receiver
                          });
                          Navigator.pop(context);
                        },
                        color: Colors.blue,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    )
                  ],
                ))));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('favor').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent: 55.0,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data.documents[index];
                  return Dismissible(
                      background: Container(color: Colors.red),
                      key: new Key('dismissible'),
                      child: ListTile(
                        key: new ValueKey(document.documentID),
                        title: new Container(
                          decoration: new BoxDecoration(
                            border:
                                new Border.all(color: const Color(0x80000000)),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new Text(
                                    "${document['Ower']} to ${document['Receiver']}"),
                              ),
                              new Text(
                                document['Favor'],
                              ),
                            ],
                          ),
                        )
                        ),
                        onDismissed: (dir) => Firestore.instance
                                .runTransaction((transaction) async {
                              await Firestore.instance
                                  .collection('favor')
                                  .document(document.documentID)
                                  .delete();
                            }),
                      );
                });
          }),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new AddFavor()));
          },
          tooltip: "Create a Favor",
          child: new Icon(Icons.add)),
    );
  }
}
