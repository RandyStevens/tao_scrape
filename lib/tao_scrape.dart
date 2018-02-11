import 'dart:io';
import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

main() {
  getHtml('http://www.mit.edu/~xela/tao.html').then((document) {
    // page title
    print(document.querySelector('title').text);
    //remove the 'Where i got this text'
    document.querySelector('p').remove();
    //Get the length of our document
    for (var p = 0; p < document.querySelectorAll('p').length;) {
      //print the text from the p tag
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
