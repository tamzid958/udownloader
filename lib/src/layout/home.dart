import 'dart:async';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:udownloader/constants.dart';
import 'package:udownloader/src/service/extract.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = '';
  var dir = '';
  String filename = '';
  double stats = 0.0;
  final _formKey = GlobalKey<FormState>();
  final _linkcontroller = TextEditingController();
  String _value = "audio";

  void settingstate() {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => setState(
        () {
          stats = statistics;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    dirname();
  }

  Future<void> dirname() async {
    dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Developed by Tamzid"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      persistentFooterButtons: [
        Text(
          'xilo soft.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kPrimaryColor,
            letterSpacing: 1,
          ),
        )
      ],
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(KdefaultPaddin),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _value,
                    items: [
                      DropdownMenuItem<String>(
                        child: Text('Video'),
                        value: 'video',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Audio'),
                        value: 'audio',
                      ),
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Choose Something';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _linkcontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.content_paste),
                    border: OutlineInputBorder(),
                    hintText: 'Enter YouTube Link',
                    helperText:
                        "Hit the share icon and select copy url in the youtube.",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton.icon(
                    color: kPrimaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        // Process data.
                        url = _linkcontroller.text;

                        if (_value == "audio") {
                          extractaudio(url);
                        } else if (_value == "video") {
                          extractvideo(url);
                        }
                        settingstate();
                      }
                    },
                    icon: Icon(
                      Icons.done,
                      color: kTextLightColor,
                    ),
                    label: Text(
                      "Submit",
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    filename1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                stats == 1.0
                    ? Column(
                        children: [
                          Text(
                            "Download Complete.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text("Saved in $dir"),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          value: stats,
                          strokeWidth: 5,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
