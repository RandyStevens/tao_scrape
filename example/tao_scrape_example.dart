import 'dart:io';
import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

main() {
  //TODO:WRITE TO FIREBASE WITH AN item CLASS THAT HAS key AND text PROPERTIES
  final url = 'http://www.mit.edu/~xela/tao.html';

  //TODO: item CLASS WILL GO HERE
  ///NEEDS: index, text

  

  getHtml(url).then((document) {
    // page title
    //TODO: WRAP THIS IN FUNCTION THAT WRITES THE TITLE TO FIREBASE
    print(document.querySelector('title').text);
    //remove the 'Where i got this text'
    document.querySelector('p').remove();
    //Get the length of our document
    //protip p++ and p+1 act different?
    for (var p = 0; p < document.querySelectorAll('p').length; p+1) {
      //print the text from the p tag
      //TODO: WRAP THIS IN FUNCTION THAT WRITES THE TEXT TO FIREBASE
      print(document.querySelector('p').text);
      //remove the first p tag before the loop ends
      document.querySelector('p').remove();
    }
  });
}

// fetch and parse the HTML from [url]
Future<Document> getHtml(String url) =>
    new HttpClient()
        .getUrl(Uri.parse(url))
        .then((req) => req.close())
        .then((res) => res
        .asyncExpand((bytes) => new Stream.fromIterable(bytes))
        .toList())
        .then((bytes) => parse(bytes, sourceUrl: url));
