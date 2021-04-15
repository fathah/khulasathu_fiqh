import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:khulasathufiqh/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFViewerApp extends StatefulWidget {
  String fileUrl;
  int pageNum;
  int indexNum;
  PDFViewerApp({this.fileUrl, this.pageNum, this.indexNum});
  @override
  _PDFViewerAppState createState() => _PDFViewerAppState();
}

class _PDFViewerAppState extends State<PDFViewerApp> {
  int defaultPage;
  bool isDark = false;
  int currentPage = 0;

  Future saveTheme(bool mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', mode);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('theme');
  }

  @override
  void initState() {
    setState(() {
      defaultPage = widget.pageNum;
    });
    getTheme().then((value) {
      if (value != null && value) {
        setState(() {
          isDark = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            // title: Row(
            //   children: <Widget>[
            //     IconButton(
            //         icon: Icon(
            //           isDark ? Icons.brightness_4 : Icons.brightness_5,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           isDark
            //               ? saveTheme(false).then((value) {
            //                   setState(() {
            //                     isDark = false;
            //                   });
            //                 })
            //               : saveTheme(true).then((value) {
            //                   setState(() {
            //                     isDark = true;
            //                   });
            //                 });
            //         }),
            //     IconButton(
            //         icon: Icon(
            //           Icons.launch,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           goToPage(context, widget.fileUrl, widget.indexNum);
            //         }),
            //   ],
            // ),
            backgroundColor: mainColor,
            actions: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    (widget.indexNum == 999)
                        ? "خلاصة الفقه الإسلامية"
                        : chapters[widget.indexNum][0],
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: mainFontArabic),
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              PDFView(
                filePath: widget.fileUrl,
                defaultPage: widget.pageNum,
                onError: (error) => print(error),
                swipeHorizontal: true,
                nightMode: isDark,
                onPageChanged: (page, total) {
                  setState(() {
                    currentPage = page + 1;
                  });
                },
              ),
              Positioned(
                  bottom: 0,
                  right: 20,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Text(
                        currentPage.toString(),
                        style: TextStyle(color: Colors.white),
                      )))
            ],
          )),
    );
  }

  goToPage(context, fileUrl, indexNum) {
    var size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        backgroundColor: Colors.white38,
        context: context,
        builder: (context) {
          return Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 45),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Go to a Page")),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Center(
                        child: Container(
                          width: size.width * 0.22,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                hintText: "Enter Page"),
                            onSubmitted: (value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return PDFViewerApp(
                                  fileUrl: fileUrl,
                                  pageNum: int.parse(value),
                                  indexNum: indexNum,
                                );
                              }));
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
