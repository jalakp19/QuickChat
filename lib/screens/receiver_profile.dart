import 'package:flutter/material.dart';
import 'package:quick_chat/services/crud.dart';

class ReceiverProfile extends StatefulWidget {
  final String email;
  ReceiverProfile({this.email});

  @override
  _ReceiverProfileState createState() => _ReceiverProfileState();
}

class _ReceiverProfileState extends State<ReceiverProfile> {
  CRUDMethods crudMethods = new CRUDMethods();

  Widget userNameDisplay;
  Widget aboutDisplay;
  Widget profilePicDisplay;

  Widget _circleAvatar() {
    return Stack(
      children: [
        profilePicDisplay,
      ],
    );
  }

  @override
  void initState() {
    setState(() {
      userNameDisplay = crudMethods.getUserNameWid(widget.email);
      aboutDisplay = crudMethods.getAbout(widget.email);
      profilePicDisplay = crudMethods.getProfilePic(widget.email);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              widget.email,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          color: Color(0xFF128C7E),
        ),
        elevation: 0,
      ),
      body: Container(
        child: Stack(
          children: [
            CustomPaint(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              painter: HeaderCurvedContainer(),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  _circleAvatar(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Username',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0005,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color(0xFF128C7E),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: userNameDisplay,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'About',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0005,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color(0xFF128C7E),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: aboutDisplay,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double heightt = size.height / 6;

    Paint paint = Paint()..color = const Color(0xFF128C7E);
    Path path = Path()
      ..relativeLineTo(0, heightt)
      ..quadraticBezierTo(size.width / 2, heightt * 2, size.width, heightt)
      ..relativeLineTo(0, -500)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
