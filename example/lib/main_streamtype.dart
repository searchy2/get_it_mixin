import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TypeModel {
  final String name;
  final String date;

  TypeModel({this.name, this.date});
}

class GetItStreamTypeIssueModel extends ChangeNotifier {
  static StreamController<TypeModel> typeController =
      StreamController<TypeModel>.broadcast(onListen: () {
    // Fire an event straight away
    typeController.add(TypeModel(name: 'Updated'));
    // Pipe events of the broadcast stream into this stream
    typeSync.stream.pipe(typeController);
  });
  static StreamController<TypeModel> typeSync = StreamController<TypeModel>();
  Stream<TypeModel> typeStream = typeController.stream;
}

final GetIt g = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    // Future.delayed(Duration(milliseconds: 1000), () {
    //   GetItStreamTypeIssueModel.typeController.add(TypeModel(name: 'Updated'));
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TypeModel typeModel =
        watchStream((GetItStreamTypeIssueModel model) => model.typeStream, null)
            .data;
    return Column(
      children: [
        Text('Type Name: ' + typeModel?.name.toString()),
      ],
    );
  }
}
