import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddFavor extends StatefulWidget {
  @override
  AddFavorState createState() {
    return AddFavorState();
  }
}

class AddFavorState extends State<AddFavor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String favor, ower, receiver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Submit a Favor")),
        body: Builder(
          builder: (context) => Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  autovalidate: false,
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Name is required' : null,
                          onSaved: (fav) => favor = fav,
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(labelText: "Favor Name")),
                      TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Ower is required' : null,
                          onSaved: (owe) => ower = owe,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Ower of the Favor")),
                      TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Receiver is required' : null,
                          onSaved: (rec) => receiver = rec,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Reciever of the Favor")),
                      Container(
                        child: RaisedButton(
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Firestore.instance.collection('favor').add({
                                "Favor": favor,
                                "Ower": ower,
                                "Receiver": receiver
                              });
                              Navigator.pop(context);
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Please fill out all of the fields."),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ));
                            }
                          },
                          color: Colors.deepOrangeAccent,
                        ),
                        margin: EdgeInsets.only(top: 20.0),
                      )
                    ],
                  ))),
        ));
  }
}