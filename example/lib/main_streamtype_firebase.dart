import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class GetItStreamTypeIssueModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User> get user => _auth.authStateChanges();
}

final GetIt g = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  registerViewModel();
  runApp(MyApp());
}

void registerViewModel() {
  g.registerSingleton<GetItStreamTypeIssueModel>(GetItStreamTypeIssueModel());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetIt Stream Type Issues',
      home: Scaffold(body: SafeArea(child: StreamTypeIssue())),
    );
  }
}

class StreamTypeIssue extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  _StreamTypeIssueState createState() => _StreamTypeIssueState();
}

class _StreamTypeIssueState extends State<StreamTypeIssue>
    with GetItStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    watchStream((GetItStreamTypeIssueModel model) => model.user, null);
    return Column(
      children: [
        Text('Type Name: '),
      ],
    );
  }
}
