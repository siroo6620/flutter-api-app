import 'dart:convert';
import 'dart:io' as IO;

import 'package:api/student.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketIO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Server Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Client'),
        ),
        body: const BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({Key? key}) : super(key: key);

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  String serverResponse = 'Server response';
  String secondServerResponse = 'Watch me';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _makeGetRequest();
                },
                child: const Text('auto '),
              ),
              FutureBuilder(
                future: getStudent(),
                builder: (context, AsyncSnapshot<Student> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final Student student =
                        snapshot.data ?? Student(name: 'name', age: 1);
                    return Column(
                      children: [
                        Text(student.name),
                        Text(student.age.toString()),
                      ],
                    );
                  } else {
                    return (const Text('Failed'));
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _makeGetSecondRequest();
                },
                child: const Text("Send request"),
              ),
              Text(
                secondServerResponse,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  _makeGetRequest() async {
    final url = Uri.parse(_localhost());
    Response response = await get(url);
    setState(() {
      serverResponse = response.body;
    });
  }

  _makeGetSecondRequest() async {
    final url = Uri.parse(_localhost() + '/message');
    Response response = await get(url);
    setState(() {
      secondServerResponse = response.body;
    });
  }

  Future<Student> getStudent() async {
    final url = Uri.parse(_localhost());
    final dataString = await get(url);
    final Map<String, dynamic> json = jsonDecode(dataString.body);

    if (json['message'] != null) {
      final student = Student.fromJson(json['message']);
      return student;
    } else {
      return Student(name: 'name', age: 2);
    }
  }

  String _localhost() {
    if (IO.Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }
}
