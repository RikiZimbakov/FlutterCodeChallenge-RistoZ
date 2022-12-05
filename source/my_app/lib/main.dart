import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/models/repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Cubresa Risto'),
    );
  }
}

Future<List<CommitedModel>> fetchCommits() async {
  final response =
      await http.get('https://api.github.com/repos/flutter/flutter/commits');

  if (response.statusCode == 200) {
    List rejected = json.decode(response.body);
    return rejected.map((e) => CommitedModel.fromJson(e)).toList();
  } else {
    throw Exception('something wrong');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<CommitedModel>> futureRepo;

  var _counter = 0;
  @override
  void initState() {
    super.initState();
    futureRepo = fetchCommits();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
                child: FutureBuilder<List<CommitedModel>>(
              future: futureRepo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<CommitedModel>? data = snapshot.data;
                  return ListView.builder(
                    itemCount: data?.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      if (index.isNaN) {
                        return const CircularProgressIndicator(
                          color: Colors.grey,
                        );
                      }

                      return Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: Text(
                                  data![index].commit.message,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                          Text(
                              "authored by: ${data[index].commit.author.name}"),
                          Text(
                            data[index].gitSha,
                            style: TextStyle(fontSize: 5.0),
                          ),
                        ],
                      ));
                    },
                  );
                } else {
                  return const CircularProgressIndicator(
                    color: Colors.grey,
                  );
                }
              },
            ))));
  }
}
