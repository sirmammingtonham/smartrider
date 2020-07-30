import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartrider/pages/home.dart';
import 'package:smartrider/services/user_repository.dart';
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
       String email = '';
      String password = '';
      String error = '';
      final Authsystem _auth = Authsystem();
      final formkey= GlobalKey<FormState>();
      @override
      Widget build(BuildContext context) {

        final emailField = TextFormField(
          validator:(val) {
             if(val.isEmpty){
               return 'Enter an email';
             }
             else if(!val.contains("@")){
               return "Please enter a valid email";
             }
             else{
               return null;
             }
          },
          onChanged: (val){
            setState(() {
              email = val;
            });
          },
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Emails",
              hintStyle: style,
              filled: true,
              fillColor: Colors.white.withOpacity(1),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        );
        final passwordField = TextFormField(
          validator: (val){
              if(val.length<6){
              return 'Password needs to be at least 6 characters';
            }
            else if(val.isEmpty){
              return "Please enter a password.";
            }
            else{
              return null;
            }
          },
          onChanged: (val){
            setState(() {
               password = val;
            });
           
          },
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              hintStyle: style,
                 filled: true,
              fillColor: Colors.white.withOpacity(1),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        );
        final loginButon = Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(93, 188, 210,1),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async{
                if(formkey.currentState.validate()){
                 dynamic result = await _auth.signinwithEandP(email, password);
                 if(result == null){
                   setState(() {
                     error = "Wrong credentials";
                   });
                 }
                 else{
                     Navigator.push(
                              context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                                );
                 }

                }

            },
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        final signupButton = Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10.0),
          color: 	Color.fromRGBO(93, 188, 210,1),
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
        final errortext = Text(error, style: TextStyle(color: Colors.red),);
       
        

        return Scaffold(
          
          body: CustomPaint(
            painter: BluePainter(),
            child:Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: formkey,
                                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                        child:Text("SmartRider",style:GoogleFonts.montserrat(fontSize: 35),),
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
                      errortext,
                      SizedBox(
                        height:  10.0,
                      ),
                    ],
                  ),
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
    paint.color = 	Color.fromRGBO(102, 94, 255,1);
    var xcoord = width;
    var ycoord = height/2+40;
    
    canvas.drawCircle(Offset(xcoord,ycoord), 200, paint);
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

