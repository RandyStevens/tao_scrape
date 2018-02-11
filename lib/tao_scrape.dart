import 'dart:io';
import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

void list(String path) {
  try {
    Directory root = new Directory(path);
    if(root.existsSync()) {
      for(FileSystemEntity f in root.listSync()) {
        print(f.path);
      }
    }
  }
  catch(e) {
    print(e.toString());
  }
}

main(List<String> arguments) {

  getHtml('http://www.mit.edu/~xela/tao.html').then((document) {
    String title = document.querySelector('title').text.replaceAll(" ", "_");
    String path = '/Users/randalstevens/Workspace/tao_scrape/writes/';
    String txtFile = '/Users/randalstevens/Workspace/tao_scrape/writes/' + title +'.json';
    writeFile(String file, String data, FileMode mode) {
      try {
        File f = new File(file);
        RandomAccessFile rf = f.openSync(mode: mode);
        rf.writeStringSync(data);
        rf.flushSync();
        rf.closeSync(); // may call flush
        return true;
      }
      catch(e) {
        print(e.toString());
        return false;
      }
    }
    document.querySelector('p').remove();
    list(path);
    int index = 0;
    int i;
    String text;
    for (i = 0; i < document.querySelectorAll('p').length;) {
      print(index);
      print(text);
      //print the text from the p tag
      text = document.querySelector('p').text.trim().replaceAll('\"', '\'').replaceAll("\n", " ");
      writeFile(txtFile, "\n\"$index\" : \"$text\",\n", FileMode.APPEND);
      //remove the first p tag before the loop ends
      document.querySelector('p').remove();
      index++;
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
