import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class GetItSteamBuilderIssueModel extends ChangeNotifier {
  ValueNotifier<int> getItCounter = ValueNotifier(0);
}

final GetIt g = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerViewModel();
  runApp(MyApp());
}

void registerViewModel() {
  g.registerSingleton<GetItSteamBuilderIssueModel>(
      GetItSteamBuilderIssueModel());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetIt StreamBuilder Issues',
      home: Scaffold(body: SafeArea(child: StreamBuilderHotReloadIssue())),
    );
  }
}

class StreamBuilderHotReloadIssue extends StatefulWidget {
  @override
  _StreamBuilderHotReloadIssueState createState() =>
      _StreamBuilderHotReloadIssueState();
}

class _StreamBuilderHotReloadIssueState
    extends State<StreamBuilderHotReloadIssue> {
  static StreamController<int> counterController = StreamController<int>();
  Stream<int> counter = counterController.stream;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      counterController.add(1);
    });
  }

  @override
  void dispose() {
    counterController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetItCounterOutsideStreamBuilder(),
        StreamBuilder(
          stream: counter,
          builder: (context, snapshot) {
            print('Build Stream');
            if (!snapshot.hasData) return SizedBox.shrink();
            int counterValue = snapshot.data as int;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Stream Counter: ' + counterValue.toString()),
                GetItCounterInStreamBuilder(),
              ],
            );
          },
        ),
      ],
    );
  }
}

class StreamBuilderRebuildIssue extends StatefulWidget
    with GetItStatefulWidgetMixin {
  @override
  _StreamBuilderRebuildIssueState createState() =>
      _StreamBuilderRebuildIssueState();
}

class _StreamBuilderRebuildIssueState extends State<StreamBuilderRebuildIssue>
    with GetItStateMixin {
  static StreamController<int> counterController = StreamController<int>();
  Stream<int> counter = counterController.stream;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      counterController.add(1);
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      counterController.add(2);
    });
  }

  @override
  void dispose() {
    counterController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetItCounterOutsideStreamBuilder(),
        StreamBuilder(
          stream: counter,
          builder: (context, snapshot) {
            print('Build Stream');
            if (!snapshot.hasData) return SizedBox.shrink();
            // This line breaks outside WatchX rebuilds.
            // Removing it allows WatchX to rebuild correctly.
            if (snapshot.data == 1) return Text('Empty');
            int counterValue = snapshot.data as int;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Stream Counter: ' + counterValue.toString()),
                GetItCounterInStreamBuilder(),
              ],
            );
          },
        ),
      ],
    );
  }
}

class GetItCounterInStreamBuilder extends StatefulWidget
    with GetItStatefulWidgetMixin {
  @override
  _GetItCounterInStreamBuilderState createState() =>
      _GetItCounterInStreamBuilderState();
}

class _GetItCounterInStreamBuilderState
    extends State<GetItCounterInStreamBuilder> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int getItCounter =
        watchX((GetItSteamBuilderIssueModel model) => model.getItCounter);
    return Column(
      children: [
        Text('GetItCounterInStreamBuilder: ' + getItCounter.toString()),
        RaisedButton(
            onPressed: () {
              print('Update GetItCounterInStreamBuilder');
              g.get<GetItSteamBuilderIssueModel>().getItCounter.value += 1;
            },
            child: Text('Update GetIt Counter'))
      ],
    );
  }
}

class GetItCounterOutsideStreamBuilder extends StatefulWidget
    with GetItStatefulWidgetMixin {
  @override
  _GetItCounterOutsideStreamBuilderState createState() =>
      _GetItCounterOutsideStreamBuilderState();
}

class _GetItCounterOutsideStreamBuilderState
    extends State<GetItCounterOutsideStreamBuilder> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int getItCounter =
        watchX((GetItSteamBuilderIssueModel model) => model.getItCounter);
    return Column(
      children: [
        Text('GetItCounterOutsideStreamBuilder: ' + getItCounter.toString()),
        RaisedButton(
            onPressed: () {
              print('Update GetItCounterOutsideStreamBuilder');
              g.get<GetItSteamBuilderIssueModel>().getItCounter.value += 1;
            },
            child: Text('Update GetIt Counter')),
      ],
    );
  }
}
