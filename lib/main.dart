import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calorie calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool male = true;
  double weight;
  int selectedActivity;
  double age = 0.0;
  double size = 150.0;
  int calorieBase;
  int calorieActivity;

  Map activities = {
    "Weak": 0,
    "Moderate": 1,
    "Strong": 2,
  };

  Map calculeActivity = {
    0: 1.2,
    1: 1.5,
    2: 1.8
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  padding(),
                  textWithStyle(
                      "Fill all the champ to obtain your daily calories"),
                  padding(),
                  Card(
                    elevation: 10.0,
                    child: new Column(
                      children: [
                        padding(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            textWithStyle("Female", color: Colors.pink),
                            Switch(
                              value: male,
                              inactiveTrackColor: Colors.pink,
                              onChanged: (value) {
                                setState(() {
                                  male = value;
                                });
                              },
                            ),
                            textWithStyle("Male", color: Colors.blue),
                          ],
                        ),
                        RaisedButton(
                          elevation: 10.0,
                          child: Text((age != 0.0)
                              ? "Your age is : $age"
                              : "Select your age"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () => showDatePiker(),
                        ),
                        padding(),
                        textWithStyle(
                          "Your height is ${size.toInt()} cm.",
                        ),
                        Slider(
                          min: 0.0,
                          max: 300.0,
                          value: size,
                          onChanged: (double i) {
                            setState(() {
                              size = i;
                            });
                          },
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (String string) {
                            setState(() {
                              weight = double.tryParse(string);
                            });
                          },
                          decoration:
                          new InputDecoration(labelText: "Weight in kg"),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            padding(),
                            textWithStyle("What is your sport activity ?"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...activitiesRadio(),
                              ],
                            ),
                            padding(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    elevation: 10.0,
                    child: Text("Calculer"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () => caloriesCalculator(),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void caloriesCalculator() {
    if (age != 0 &&
        size != null &&
        weight != null &&
        selectedActivity != null) {
      if (male) {
        calorieBase =
            (66.4730 + (13.7516 * weight) + (5.0033 * size) - (6.7550 * age))
                .toInt();
        calorieActivity = (calorieBase * calculeActivity[selectedActivity]).toInt();
        dialog();
      }
    } else {
      alert();
    }
  }

  Future<Null> dialog() async {
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (BuildContext buildContext) {
      return SimpleDialog(
        title: textWithStyle("Your need in calories"),
        contentPadding: EdgeInsets.all(15.0),
        children: [
          padding(),
          textWithStyle("Your need in calories are: $calorieBase"),
          padding(),
          textWithStyle("Your need in calories with activity are: $calorieActivity"),
          RaisedButton(onPressed: () {
            Navigator.pop(buildContext);
          },
          child: textWithStyle("OK", color: Colors.white),
          color: Colors.blue,),
        ],
      );
    });
  }

  Future<Null> alert() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext builderContext) {
          return new AlertDialog(
            title: Text("Error"),
            content: textWithStyle(
              "all the field or not completed",
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(builderContext);
                },
                child: textWithStyle('ok', color: Colors.red),
              )
            ],
          );
        });
  }

  Padding padding() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
    );
  }

  Future<Null> showDatePiker() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (date != null) {
      print(date);
      var difference = new DateTime.now().difference(date);
      var day = difference.inDays;
      var years = (day / 365);
      setState(() {
        age = years.ceil().toDouble();
      });
    }
  }

  Text textWithStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return Text(
      data,
      textAlign: TextAlign.center,
      style: new TextStyle(color: color, fontSize: fontSize),
    );
  }

  List<Widget> activitiesRadio() {
    List<Widget> radios = [];
    activities.forEach((key, value) {
      Column radio = Column(
        children: [
          Radio(
            value: value,
            groupValue: selectedActivity,
            onChanged: (Object i) {
              setState(() {
                selectedActivity = i;
              });
            },
          ),
          textWithStyle(key, color: Colors.blue),
        ],
      );
      radios.add(radio);
    });
    return radios;
  }
}
