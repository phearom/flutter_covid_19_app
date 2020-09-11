import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

class DynamicWidget extends StatefulWidget {
  final int formId;
  final String formName;

  const DynamicWidget({Key key, this.formId, this.formName}) : super(key: key);
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  final students = [
    {"name": "Name", "type": "textbox", "required": true},
    {"name": "Age", "type": "textbox", "required": true},
    {"name": "Sex", "type": "textbox", "required": false},
    {"name": "Create Account", "type": "checkbox", "required": false},
    {"name": "Position", "type": "textbox", "required": false},
    {"name": "Reset Password", "type": "checkbox", "required": true},
    {"name": "Role", "type": "checkboxlist", "value": "{\"Admin\":false,\"User\":true}", "required": true},
    {"name": "Group", "type": "checkboxlist", "value": "{\"CS\":true,\"User\":true}", "required": true},
    {"name": "Type", "type": "textbox", "required": true},
  ];

  final courses = [
    {"name": "Physic", "type": "textbox", "required": true},
    {"name": "Chemistry", "type": "textbox", "required": true},
    {"name": "Math", "type": "textbox", "required": true},
    {"name": "Khmer", "type": "textbox", "required": true},
    {"name": "Biology", "type": "textbox", "required": false}
  ];
  var lists = List<dynamic>();
  @override
  void initState() {
    if (widget.formId == 1) {
      lists = courses;
    } else if (widget.formId == 2) {
      lists = students;
    } else {
      lists = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formId.toString() + " - " + widget.formName),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _dynamicFormBuilder(),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: _submitForm,
                  child: Text(
                    'Click Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final editControllers = List<TextEditingController>();
  final chkListSingle = Map<String, bool>();
  final xxx = Map<String, TextEditingController>(); //not work don no why
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var tmpChkListMulti = Map<String, bool>();
  var values = Map<String, bool>();
  // Map<String, bool> values = {
  //   'Apple': false,
  //   'Banana': false,
  //   'Cherry': true,
  //   'Mango': false,
  //   'Orange': false,
  // };
  var i = 0;
  _dynamicFormBuilder() {
    return Container(
      padding: EdgeInsets.all(10),
      child: lists == null
          ? Center(child: Text("There is no field for this form!!!"))
          : Form(
              key: _formKey,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  print(i);
                  print(index);
                  i++;
                  var type = lists[index]['type'].toString();
                  var name = lists[index]['name'].toString();
                  var require = lists[index]['required'].toString() == 'true';
                  //var editorSingle = TextEditingController();
                  editControllers.add(TextEditingController());

                  if (type == 'textbox') {
                    return Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: editControllers[index],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          //hintText: name,
                          labelText: name,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (val) {
                          if (require) {
                            return val.isEmpty ? "Field $name is required" : null;
                          }
                          return null;
                        },
                      ),
                    );
                  } else if (type == 'checkbox') {
                    return Container(
                      decoration: BoxDecoration(
                          //border: Border(bottom: BorderSide(width: 1)),
                          ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.all(0),
                        activeColor: Colors.green,
                        title: Text(name),
                        onChanged: (value) {
                          setState(() {
                            chkListSingle[name] = value;
                          });
                        },
                        value: chkListSingle[name] ?? false,
                      ),
                    );
                  } else if (type == 'checkboxlist') {
                    var dataRoles = jsonDecode(lists[index]['value']);

                    var mapRoles = Map<String, bool>.from(dataRoles);

                    values = mapRoles;

                    // values = {
                    //   'Apple': false,
                    //   'Banana': false,
                    //   'Cherry': true,
                    // };
                    print(values);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name, style: TextStyle(fontSize: 16)),
                        // Row(
                        //   children: <Widget>[
                        //     for (var x = 0; x < values.length; x++) ...[
                        //       Row(
                        //         children: <Widget>[
                        //           Checkbox(
                        //             onChanged: (v) {},
                        //             value: false,
                        //           ),
                        //           Text("H"),
                        //           VerticalDivider(
                        //             width: 30,
                        //           )
                        //         ],
                        //       ),
                        //     ],
                        //   ],
                        // )
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          //scrollDirection: Axis.vertical,
                          children: values.keys.map((String key) {
                            return CheckboxListTile(
                              title: Text(key),
                              value: tmpChkListMulti[key] ?? values[key], //values[key],
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.pink,
                              checkColor: Colors.white,
                              onChanged: (bool value) {
                                setState(() {
                                  tmpChkListMulti[key] = value;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  } else {
                    return Divider(
                      height: 0,
                    );
                  }
                },
              ),
            ),
    );
  }

  _submitForm() {
    if (lists == null) {
      print('No field for this forms');
      return;
    }
    final form = _formKey.currentState;
    if (form.validate()) {
      print('validate');
    } else {
      print('invalidate');
      return;
    }

    var m = Map<String, Object>();
    for (var i = 0; i < lists.length; i++) {
      var name = lists[i]['name'].toString();
      var type = lists[i]['type'].toString();
      if (type == 'textbox') {
        print(name + "-" + editControllers[i].text);
        m[name] = editControllers[i].text;
      } else if (type == 'checkbox') {
        m[name] = chkListSingle[name];
      }
    }
    print(m);
  }
}
