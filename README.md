# tao_scrape

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage
Clone into your working directory then:
    
    cd /tao_scrape

run:
    
    pub get

Create a directory inside tao_scrape called 

    writes

Create a new config.dart inside the /lib/ directory
add a new class inside config.dart

    class Config {
      String url;
      String path;
      Config(this.url, this.path);
    }
    Config target = new Config(
            'http://www.mit.edu/~xela/tao.html', 
             '/path/to/this/directory/writes/');    

Modify the path inside the Config target declaration to the path where you created the /writes/ directory

A simple usage example:

    dart tao_scrape_example.dart