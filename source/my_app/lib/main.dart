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
    //gets the last 30 or so commits from this api call
    List commits = json.decode(response.body);
    return commits.map((e) => CommitedModel.fromJson(e)).toList();
  } else {
    throw Exception('You were unable to retrieve a successful response');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<CommitedModel>> futureRepo;

  @override
  void initState() {
    super.initState();
    futureRepo = fetchCommits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      return GestureDetector(
                          onTap: (() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndepthCommit(
                                      message: data[index].commit.message),
                                ));
                          }),
                          child: Card(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 300),
                                    child: Text(
                                      data![index].commit.message,
                                      style: const TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  "authored by: ${data[index].commit.author.name}"),
                              Text(
                                data[index].gitSha,
                                style: const TextStyle(fontSize: 5.0),
                              ),
                            ],
                          )));
                    },
                  );
                } else {
                  return const CircularProgressIndicator(
                    color: Colors.grey,
                  );
                }
              },
            )));
  }
}

/* IndepthCommit:
2nd screen that gets navigated to on click*/
class IndepthCommit extends StatelessWidget {
  const IndepthCommit({super.key, required this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
