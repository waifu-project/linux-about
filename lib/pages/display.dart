import 'package:about/common/io.dart';
import 'package:about/common/open.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key}) : super(key: key);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  String _displaySize = "";

  String _displayInch = "";

  String get displayText {
    return "$_displayInch ($_displaySize)";
  }

  @override
  void initState() {
    setState(() {
      _displaySize = KitIO.displaySize;
      _displayInch = KitIO.displayInch;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/display.png"),
              SizedBox(
                height: 24,
              ),
              Text(
                "Buit-in display",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * .1,
          right: MediaQuery.of(context).size.width * .06,
          child: GestureDetector(
            onTap: () {
              // TODO
              Open.display();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color.fromRGBO(0, 0, 0, .1),
                ),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .5,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 3,
              ),
              child: Text(
                "displays preferences",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
