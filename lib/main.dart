import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khulasathufiqh/pdfView.dart';
import 'package:khulasathufiqh/strings.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'خلاصة الفقه الإسلامية',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: "Montserrat",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String pdfFIleUrl;
  String copyRight = "Manzil Developers";
  Future getPDF() async {
    try {
      var data = await rootBundle.load('assets/khulasa.pdf');
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File pdfFile = File("${dir.path}/khulasa.pdf");

      File assetFile = await pdfFile.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      print("file error found machans");
    }
  }

  @override
  void initState() {
    getPDF().then((value) {
      setState(() {
        pdfFIleUrl = value.path;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            width: size.width,
            height: size.height * 0.25,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xff18413D), Color(0xff386D5B)])),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),

          //Text(chapters[index][0])
          Container(
            height: size.height * 0.75,
            child: ListView.builder(
              itemCount: 63,
              itemBuilder: (BuildContext context, int index) {
                int indexPlus = index + 1;
                String indexNumber = indexPlus.toString();
                String replace1 = indexNumber.replaceAll('0', '٠');
                String replace2 = replace1.replaceAll('1', '١');
                String replace3 = replace2.replaceAll('2', '٢');
                String replace4 = replace3.replaceAll('3', '٣');
                String replace5 = replace4.replaceAll('4', '٤');
                String replace6 = replace5.replaceAll('5', '٥');
                String replace7 = replace6.replaceAll('6', '٦');
                String replace8 = replace7.replaceAll('7', '٧');
                String replace9 = replace8.replaceAll('8', '٨');
                String replace10 = replace9.replaceAll('9', '٩');
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return PDFViewerApp(
                              fileUrl: pdfFIleUrl,
                              pageNum: chapters[index][1],
                              indexNum: index,
                            );
                          },
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 8),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.teal.withOpacity(0.2),
                              child: Text(
                                replace10,
                                style: TextStyle(
                                    color: mainDarkColor, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                chapters[index][0],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: mainFontArabic, fontSize: 27),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black12,
                      height: 0,
                    ),
                    (index == 62)
                        ? Container(
                            color: mainColor,
                            width: size.width,
                            height: 45,
                            child: Center(
                              child: Text(
                                copyRight,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 0,
                          )
                  ],
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: FloatingActionButton(
            backgroundColor: mainColor,
            onPressed: () {
              showSearch(
                  context: context, delegate: Search(pdfUrl: pdfFIleUrl));
            },
            child: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

class Search extends SearchDelegate<String> {
  String pdfUrl;
  Search({this.pdfUrl});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  Widget buildSuggestions(BuildContext context) {
    List suggestions = List();
    chapters.forEach((postList) {
      if (postList[0].contains(query)) suggestions.add(postList);
    });
    final suggestion = query.isEmpty ? chapters : suggestions;
    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (BuildContext context, int index) {
        var title = suggestion[index][0];
        return Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.3))),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListTile(
              leading: Icon(
                Icons.class_,
                color: mainColor,
              ),
              title: Text(
                title,
                style: TextStyle(fontFamily: mainFontArabic, fontSize: 25),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return PDFViewerApp(
                      fileUrl: pdfUrl,
                      pageNum: suggestion[index][1],
                      indexNum: 999,
                    );
                  },
                ));
              },
            ),
          ),
        );
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return Home();
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: mainColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image(image: AssetImage("assets/images/splash.png")),
      ),
    );
  }
}
