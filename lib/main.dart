/*
################################################################################
#                                 Help Guide                                   #
################################################################################
--------------------------------------------------------------------------------
###########################
#      Help Guide No.1    #
###########################
  If you encounter errors please use Terminal inside the project folder
  and type this command "flutter pub add material" to update the dependencies
  in the "pubspec.yaml" file.

###########################
#      Help Guide No.2    #
###########################
  If you encounter not to run the flutter in project folder you may locate the
  "Flutter pub get" in right click the "pubspec.yaml" file and navigate to
  flutter and select "Flutter pub get"

###########################
#      Help Guide No.3    #
###########################
  Else if you encounter not to run the flutter because an error
  "Warning: Your Flutter application is created using an older version of the
  Android embedding. It's being deprecated in favor of Android embedding v2."
  the solution is to delete your "android folder" and "ios folder" and create
  new flutter in cmd type "flutter create calculator" and copy the android and
  ios folder to the project directory and re run again.
--------------------------------------------------------------------------------
################################################################################
#                   Created by Francis Carlo A. Manlangit                      #
################################################################################
*/

import 'package:calculator/Currency/convert.dart'; /* For location of the file */
import 'package:calculator/Internet/internet.dart'; /* For location of the file */
import 'package:calculator/Temperature/temp.dart'; /* For location of the file */
import 'package:flutter/material.dart'; /* For dependencies */
import 'package:flutter/services.dart'; /* For dependencies */
import 'Calculator/calculator.dart'; /* For location of the file */
import 'Calculator/number-display.dart'; /* For location of the file */
import 'Calculator/calculator-buttons.dart'; /* For location of the file */
import 'Calculator/history.dart'; /* For location of the file */

/*
  This the main application to be run first declared the functions.
 */
void main() {
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
  This is the Title of the APP and the Title when opening the app.
 */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*
  Declaring the operations used to calculate the calculator.
 */
class _MyHomePageState extends State<MyHomePage> {
  bool isNewEquation = true;
  List<double> values = [];
  List<String> operations = [];
  List<String> calculations = [];
  String calculatorString = '';

  /*
    This part is for widget on the left 3 lines at the top.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
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

        /*
          This section declared for Top or header of the app.
         */
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.history), // icon history if the calculator performing the computation.
              onPressed: () {
                _navigateAndDisplayHistory(context);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            NumberDisplay(value: calculatorString),
            CalculatorButtons(onTap: onPressed),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        )

    );

  }

  _navigateAndDisplayHistory(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => History(operations: calculations))
    );

    /*
      This area will restrict the calculation if the first did not input and
      also the second input this will ignored to perform new operations.
     */
    if (result != null) {
      setState(() {
        isNewEquation = false;
        calculatorString = Calculator.parseString(result);
      });
    }
  }

  /*
    This area will restrict the multiple operation such as 1++1 or 1xx1 or 1//1.
   */
  void onPressed({String buttonText}) {
    // Standard mathematical operations
    if (Calculations.OPERATIONS.contains(buttonText)) {
      return setState(() {
        operations.add(buttonText);
        if (calculatorString.isNotEmpty && operations.single != "10") {
          calculatorString += buttonText;
        }

      }
      );
    }

    // On CLEAR press will erase all computation of the calculator.
    if (buttonText == Calculations.CLEAR) {
      return setState(() {
        operations.add(Calculations.CLEAR);
        calculatorString = "";
        operations.clear();
      });
    }

    // On Equals press will do calculations and give the results.
    if (buttonText == Calculations.EQUAL) {
      String newCalculatorString = Calculator.parseString(calculatorString);

      return setState(() {
        if (newCalculatorString != calculatorString) {
          // only add evaluated strings to calculations array
          calculations.add(calculatorString);
        }
        operations.add(Calculations.EQUAL);
        calculatorString = newCalculatorString;
        isNewEquation = false;
        operations.clear();
      });
    }

    // Period button press
    if (buttonText == Calculations.PERIOD) {
      return setState(() {
        if (operations.length<1) {
          calculatorString = Calculator.addPeriod(calculatorString);
        }
        else {
          if(calculatorString.endsWith('+')) { // This Operation "PLUS" will restrict to type period must be number first.

          }
          else if(calculatorString.endsWith('-')) { // This Operation "MINUS" will restrict to type period must be number first.

          }
          else if(calculatorString.endsWith('X')) { // This Operation "MULTIPLICATION" will restrict to type period must be number first.

          }
          else if(calculatorString.endsWith('/')) { // This Operation "DIVISION" will restrict to type period must be number first.

          }
          else {
            if (operations.isNotEmpty) {
              calculatorString = Calculator.addPeriod(calculatorString);
            }
          }
        }
      });
    }

    // New calculation when operation are done.
    setState(() {
      if (!isNewEquation && operations.isEmpty) {
        calculatorString = buttonText;
        isNewEquation = true;
      } else {
        calculatorString += buttonText;
      }
    });
  }
}