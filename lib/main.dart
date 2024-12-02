import 'package:flutter/material.dart';
import 'dart:io';
class MyHttpOverrides extends HttpOverrides{ 
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main(){
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wake on Lan app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 22, 22, 22)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wake on Lan app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<MyHomePage> {
  void sendMagicPacket(String macAddress, String subNetMask) async {
    final List<int> macBytes = macAddress.split(':').map((e) => int.parse(e, radix: 16)).toList();
    final List<int> packet = List<int>.filled(6, 0xFF) + List<List<int>>.generate(16, (_) => macBytes).expand((x) => x).cast<int>().toList();
    final RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.send(packet, InternetAddress(subNetMask), 11);
    socket.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("起動したいPCを選んでください"),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 22, 22, 22)),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:SizedBox(
          
          width:MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text("起動",
                  style:(
                    TextStyle(
                      color: Color.fromARGB(255, 240, 240, 240),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    )
                  )
                ),
              ),

              Container(
                margin: const EdgeInsets.all(16),
                child:ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 231, 231, 231),
                    foregroundColor: Colors.black,
                    shape: const StadiumBorder(),
                    elevation: 0, // Shadow elevation
                    shadowColor: const Color.fromARGB(255, 255, 255, 255), // Shadow color
                  ),
                  onPressed: () {
                    try{
                      // パケット送信処理
                      print("ok");
                      ()async{
                        sendMagicPacket("74:8F:3C:C3:63:96", "255.255.255.0");
                      };

                    }catch(e){
                      print(e);
                    }
                  },
                  icon: Icon(Icons.power),
                  label: const Text(
                    '起動',
                    style:(
                      TextStyle(
                        color: Color.fromARGB(255, 22, 22, 22),
                        fontSize: 16
                      )
                    )
                  ),
                ),
              ) 
            ],
          ),
        )
      ),
    );
  }
}
