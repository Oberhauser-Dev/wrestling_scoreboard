import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/weight_class.dart';
import 'package:wrestling_scoreboard/ui/match_sequence.dart';

import 'data/gender.dart';
import 'data/lineup.dart';
import 'data/participant.dart';
import 'data/participant_status.dart';
import 'data/person.dart';
import 'data/team_match.dart';
import 'data/wrestling_style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wrestling Scoreboard',
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.dark,
      home: MatchSequence(initMatch()),
    );
  }

  TeamMatch initMatch() {
    WeightClass wc57 = WeightClass(57, WrestlingStyle.free);
    WeightClass wc130 = WeightClass(130, WrestlingStyle.greco);
    WeightClass wc61 = WeightClass(61, WrestlingStyle.greco);
    WeightClass wc66 = WeightClass(66, WrestlingStyle.free);
    WeightClass wc75 = WeightClass(75, WrestlingStyle.free, name: '75 kg A');

    Participant r1 = Participant(prename: 'Lisa', surname: 'Simpson', gender: Gender.female);
    Participant r2 = Participant(prename: 'Bart', surname: 'Simpson', gender: Gender.male);
    Participant r3 = Participant(prename: 'March', surname: 'Simpson', gender: Gender.female);
    Participant r4 = Participant(prename: 'Homer', surname: 'Simpson', gender: Gender.male);
    ParticipantStatus rS1 = ParticipantStatus(participant: r1, weightClass: wc57);
    ParticipantStatus rS2 = ParticipantStatus(participant: r2, weightClass: wc61);
    ParticipantStatus rS3 = ParticipantStatus(participant: r3, weightClass: wc75);
    ParticipantStatus rS4 = ParticipantStatus(participant: r4, weightClass: wc130);
    Team homeTeam = Team(name: 'Springfield Wrestlers');
    Lineup home = Lineup(team: homeTeam, participantStatusList: [rS1, rS2, rS3, rS4]);

    Participant b1 = Participant(prename: 'Meg', surname: 'Griffin', gender: Gender.female);
    Participant b2 = Participant(prename: 'Chris', surname: 'Griffin', gender: Gender.male);
    Participant b3 = Participant(prename: 'Lois', surname: 'Griffin', gender: Gender.female);
    Participant b4 = Participant(prename: 'Peter', surname: 'Griffin', gender: Gender.male);
    ParticipantStatus bS1 = ParticipantStatus(participant: b1, weightClass: wc57);
    ParticipantStatus bS2 = ParticipantStatus(participant: b2, weightClass: wc66);
    ParticipantStatus bS3 = ParticipantStatus(participant: b3, weightClass: wc75);
    ParticipantStatus bS4 = ParticipantStatus(participant: b4, weightClass: wc130);
    Team guestTeam = Team(name: 'Quahog Hunters');
    Lineup guest = Lineup(team: guestTeam, participantStatusList: [bS1, bS2, bS3, bS4]);

    Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
    return TeamMatch(home, guest, referee);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
