import 'dart:math';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() => runApp(MyApp());

class CounterStore {
  CounterStore(this.count);
  int count;

  void increment() async {
    await Future.delayed(Duration(seconds: 1));
    if (Random().nextBool()) {
      throw Exception('A Counter Error');
    }
    count++;
  }
}

class MyApp extends StatelessWidget {
  final counterRM = ReactiveModel.create(CounterStore(0));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyScaffold(
        counterRM: counterRM,
      ),
    );
  }
}

class _MyScaffold extends StatelessWidget {
  final ReactiveModel<CounterStore> counterRM;

  const _MyScaffold({Key key, this.counterRM}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      title: 'Flutter Demo Home Page',
      counterRM: counterRM,
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title, this.counterRM}) : super(key: key);
  final String title;
  final ReactiveModel<CounterStore> counterRM;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            //Subscribing to the counterRM using StateBuilder
            WhenRebuilder<CounterStore>(
              observe: () => counterRM,
              onIdle: () => Text('Tap on the FAB to increment the counter'),
              onWaiting: () => CircularProgressIndicator(),
              onError: (error) => Text(counterRM.error.message),
              onData: (data) => Text(
                '${data.count}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //set the state of the counter and notify observer widgets to rebuild.
          counterRM.setState((s) => s.increment());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
