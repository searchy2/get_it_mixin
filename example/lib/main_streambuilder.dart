import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class GetItSteamBuilderIssueModel extends ChangeNotifier {
  ValueNotifier<String> getItCounter = ValueNotifier('0');
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
      home: Scaffold(body: SafeArea(child: CounterApp())),
    );
  }
}

class CounterApp extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> with GetItStateMixin {
  static StreamController<int> counterController = StreamController<int>();
  Stream<int> counter = counterController.stream;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      counterController.add(1);
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      counterController.add(2);
    });
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
            if (snapshot.data == 1)
              return Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator());
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
    String getItCounter =
        watchX((GetItSteamBuilderIssueModel model) => model.getItCounter);
    return Column(
      children: [
        Text('GetItCounterInStreamBuilder: ' + getItCounter.toString()),
        RaisedButton(
            onPressed: () {
              print('Update GetItCounterInStreamBuilder');
              g.get<GetItSteamBuilderIssueModel>().getItCounter.value = '2';
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
    String getItCounter =
        watchX((GetItSteamBuilderIssueModel model) => model.getItCounter);
    return Column(
      children: [
        Text('GetItCounterOutsideStreamBuilder: ' + getItCounter.toString()),
        RaisedButton(
            onPressed: () {
              print('Update GetItCounterOutsideStreamBuilder');
              g.get<GetItSteamBuilderIssueModel>().getItCounter.value = '1';
            },
            child: Text('Update GetIt Counter')),
      ],
    );
  }
}
