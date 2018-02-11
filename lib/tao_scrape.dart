import 'dart:io';
import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:firebase/firebase.dart' as fb;

main() async {
  try {
    fb.initializeApp(
        apiKey: "AIzaSyBjLdAuoM78gnoN8tbnO0pHp4VRrE-FG04",
        authDomain: "tao-weekend.firebaseapp.com",
        databaseURL: "https://tao-weekend.firebaseio.com",
        projectId: "tao-weekend",
        storageBucket: "tao-weekend.appspot.com");
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}


class taoItem {
  final fb.DatabaseReference ref;
  Object text;
  Object index;

  taoItem newItem = new taoItem();

  taoItem()
      : ref = fb.database().ref("tao-weekend"),
        index = fb.database().ref("tao-weekend").child('index'),
        text = fb.database().ref('tao-weekend').child('index').child('text');

  void scrape(String target, bool isRunning) {
    if (isRunning = true) {

      getHtml(target).then((document) async {
        var map = {index : text};
        document.querySelector('title').text;
        document.querySelector('p').remove();
        for (var p = 0; p < document.querySelectorAll('p').length;) {
          int indexValue = 1;
          document.querySelector('p').text = text;
          index = indexValue.toString();
          document.querySelector('p').remove();
          await ref.push(map).future;
          index = "";
          text = "";
          indexValue++;
        }
      });
      isRunning = false;
    }
  }

 }
/// fetch and parse the HTML from [url]
Future<Document> getHtml(String url) =>
    new HttpClient()
        .getUrl(Uri.parse(url))
        .then((req) => req.close())
        .then((res) => res
        .asyncExpand((bytes) => new Stream.fromIterable(bytes))
        .toList())
        .then((bytes) => parse(bytes, sourceUrl: url));

