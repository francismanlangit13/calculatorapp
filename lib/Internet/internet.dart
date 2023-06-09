import 'package:calculator/Currency/convert.dart';
import 'package:calculator/main.dart';
import 'package:calculator/Temperature/temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main3() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) // This will lock only portrait only auto rotate blocked.
      .then((value) => runApp(MyApp()));
}

/*
  Popup AlertDialog information the calculator APP.
 */
void alertDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('About Calculator APP'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Simple Calculator with 3 conversion \n 1. Currency '
                  '\n 2. Temperature \n 3. Internet \n'),
              Text('Members \n Francis Carlo A. Manlangit \n Christine Mae Balmadres \n'
                  ' Cindy Sapalleda \n Yvesh Hemoroz \n Norven Dumalagan Tero'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

/*
  This is the Theme and color of a new window color orange.
 */
class MyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: TempApp(),
    );

  }
}

/*
  Declared the variable.
 */
class TempApp extends StatefulWidget {
  @override
  TempState createState() => TempState();
}

class TempState extends State<TempApp> {
  double input;
  double output;
  bool speed;

  /*
    Allows to use external keyboard and restrict to numbers only not allowed
    letters and characters in this code area.
   */
  @override
  void initState() {
    super.initState();
    input = 0.0;
    output = 0.0;
    speed = true;
  }

  @override
  Widget build(BuildContext context) {
    TextField inputField = TextField(
      keyboardType: TextInputType.number,
      onChanged: (str) {
        try {
          input = double.parse(str);
        } catch (e) {
          input = 0.0;
        }
      },
      decoration: InputDecoration(
        labelText:
        "Input a Value in ${speed == false ? "Megabit/s" : "Kilobits/s"}",
      ),
      textAlign: TextAlign.center,
    );

    AppBar appBar = AppBar(
      title: Text("Internet Calculator"),
    );

    /*
      Buttons circle when selected this will perform the calculations in "Kilobits"
      or "Megabits".
     */
    Container tempSwitch = Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Text("Kilobits"),
          Radio<bool>(
              groupValue: speed,
              value: false,
              onChanged: (v) {
                setState(() {
                  speed = v;
                });
              }),
          Text("Megabits"),
          Radio<bool>(
              groupValue: speed,
              value: true,
              onChanged: (v) {
                setState(() {
                  speed = v;
                });
              }),
        ],
      ),
    );

    /*
      This will calculate based on the selected from circle buttons which is
      "Kilobits" and "Megabits" and this area will execute the inputted user.
     */
    Container calcBtn = Container(
      child: ElevatedButton(
        child: Text("Calculate"),
        onPressed: () {
          setState(() {
            speed == false
                ? output = (input) * (1000) // 1000 is the standard exchange rate.
                : output = (input) / (1000); // 1000 is the standard exchange rate.
          });
          AlertDialog dialog = AlertDialog(
            content: speed == false
                ? Text(
                "${input.toStringAsFixed(2)} Megabits = ${output.toStringAsFixed(2)} Kilobits")
                : Text(
                "${input.toStringAsFixed(2)} Kilobits = ${output.toStringAsFixed(2)} Megabits"),
          );
          showDialog(builder: (context) => dialog, context: context);
        },
      ),
    );

    /*
      This part is for widget on the left 3 lines at the top.
     */
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text("\n\n\n\nSimple Calculator",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Calculator'),
              onTap: main, // This is the main.dart
            ),
            ListTile(
              title: Text('Peso to Dollar Converter'),
              onTap: main2, // This locates "lib/Currency/convert.dart"
            ),
            ListTile(
              title: Text('Temperature Converter'),
              onTap: main1, // This locates "lib/Temperature/temp.dart"
            ),
            ListTile(
              title: Text('Internet Converter'),
              onTap: main3, // This locates "lib/Internet/internet.dart"
            ),
            ListTile(
              title: Text('About Calculator APP'),
              onTap: () => alertDialog(context), // defined variable alertDialog in void main.
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            inputField,
            tempSwitch,
            calcBtn,
          ],
        ),
      ),
    );
  }
}