import 'dart:io';
import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'config.dart' as config;

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

  getHtml(config.target.url).then((document) {
    ///If you want a different file name or prefer camel case uncomment next line
//    String title = document.querySelector('title').text.replaceFirst(" o", " O").replaceAll(" ", "").replaceFirst('T', 't');
    String title = document.querySelector('title').text.replaceAll(" ", "_");
    String path = config.target.path;
    //Grabs the title, inserts it into the path, adds the .json filetype
    String txtFile = path + title +'.json';
    //print the title of the file
    print(title);
    //write file logic
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
    //Remove the "where i got this" text
    document.querySelector('p').remove();

    int index = 0;
    int i;
    String text;
    writeFile(txtFile, "{\n", FileMode.WRITE);
    //we start at 1 so that we can encode to .json manually
    for (i = 1; i < document.querySelectorAll('p').length;) {
      //print the text you are encoding.
      print(index);
      print(text);
      //get the text from the p tag
      text = document.querySelector('p').text.trim().replaceAll('\"', '\'').replaceAll("\n", " ");
      //write it to the file
      writeFile(txtFile, "\n\"$index\" : \"$text\",\n", FileMode.APPEND);
      //remove the first p tag before the loop ends
      document.querySelector('p').remove();
      index++;
    }
    //JSON doesn't like the last item to have a comma
    writeFile(txtFile, "\n\"$index\" : \"$text\"\n", FileMode.APPEND);
    writeFile(txtFile, "}", FileMode.APPEND);
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
