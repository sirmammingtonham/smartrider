import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';

 class Loginpage extends StatelessWidget {
      // This widget is the root of your application.
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'smart rider login',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Smartrider Login'),
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
      TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

      @override
      Widget build(BuildContext context) {

        final emailField = TextField(
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Username",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        );
        final passwordField = TextField(
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        );
        final loginButon = Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {},
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        final signupButton = Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.lightBlue,
          child: MaterialButton(
           minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
                Navigator.push(
                   context,
                MaterialPageRoute(builder: (context) => Signuppage()),
                  );
            },
            child: Text("Signup",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        

        return Scaffold(
          
          body: CustomPaint(
            painter: BluePainter(),
            child:Center(
            child: Container(
              
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                      child:Text("SmartRider",style:GoogleFonts.prompt(fontSize: 25),),
                    ),
                    SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        "assets/ridericon.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                    signupButton,
                    SizedBox(
                      height:  10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        );
      }
    }
  class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint(); 

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.blue.shade700;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    // Start paint from 20% height to the left
    ovalPath.moveTo(0, height * 0.2);

    // paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);

    // Paint a curve from current position to bottom left of screen at width * 0.1
    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);

    // draw remaining line to bottom left side
    ovalPath.lineTo(0, height);

    // Close line to reset it back
    ovalPath.close();

    paint.color = Colors.blue.shade600;
    canvas.drawPath(ovalPath, paint);
  }
    
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
  }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   ui.Image image;
//   bool isImageloaded = false;
//   void initState() {
//     super.initState();
//     init();
//   }

//   Future <Null> init() async {
//     final ByteData data = await rootBundle.load('images/lake.jpg');
//     image = await loadImage(new Uint8List.view(data.buffer));
//   }

//   Future<ui.Image> loadImage(List<int> img) async {
//     final Completer<ui.Image> completer = new Completer();
//     ui.decodeImageFromList(img, (ui.Image img) {
//       setState(() {
//         isImageloaded = true;
//       });
//       return completer.complete(img);
//     });
//     return completer.future;
//   }

//   Widget _buildImage() {
//     if (this.isImageloaded) {
//       return new CustomPaint(
//           painter: new ImageEditor(image: image),
//         );
//     } else {
//       return new Center(child: new Text('loading'));
//     }
//   }
//   @override
//   Widget build(BuildContext context) {

//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new Container(
//         child: _buildImage(),
//       )
//     );
//   }
// }

// class ImageEditor extends CustomPainter {


//   ImageEditor({
//     this.image,
//   });

//   ui.Image image;

//   @override
//   void paint(Canvas canvas, Size size) {
//     //ByteData data = image.toByteData();
//     canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }

// }

