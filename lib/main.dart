import 'package:flutter/material.dart';
import 'package:stepper/stepper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
      //drawer: NavBar(),
      appBar: AppBar(
        title: const Center(child: Text('Customizable Stepper')),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 10.0,
          right: 16,
        ),
        child: CustomizedStepper(
          steps: [
            CustomizedStep(
              title: "Activation",
              widget: Center(
                child: Text("Step 1"),
              ),
              state: CustomizedStepState.SELECTED,
              isValid: true,
            ),
            CustomizedStep(
              title: "Attendance",
              widget: Center(
                child: Text('Step 2'),
              ),
              isValid: true,
            ),
            CustomizedStep(
              title: "Attendance 2",
              widget: Center(child: Text('Step 3')),
              isValid: true,
            ),
            CustomizedStep(
              title: "Save",
              widget: Center(child: Text('Step 4')),
              isValid: true,
            ),

          ],
          buttons: false,
          selectedColor: const Color(0xff297bb9),
          unSelectedColor: Colors.blue.shade200,
          leftBtnColor: const Color(0xc11f438f),
          rightBtnColor: const Color(0xff449bb6),
          selectedOuterCircleColor: const Color(0xc11f438f),
          type: Type.LEFT,
          circleRadius: 30,
          onComplete: () {
            print("completed");
          },
          textStyle: const TextStyle(
            fontSize: 12,
            //fontWeight: FontWeight.bold,
            decoration: null,
          ), btnTextColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
