import 'dart:io' show File, HttpRequest, HttpServer, Platform, WebSocket, WebSocketTransformer;
import 'dart:async' show runZoned;
import 'package:http_server/http_server.dart' show VirtualDirectory;

List<WebSocket> connections;

void main() {
  // Assumes the server lives in bin/ and that `pub build` ran.
  var buildUri = Platform.script.resolve('../build');

  var staticFiles = new VirtualDirectory(buildUri.toFilePath());
  staticFiles
      ..allowDirectoryListing = true
      ..directoryHandler = (dir, request) {
    // Redirect directory-requests to piratebadge.html file.
    var indexUri = new Uri.file(dir.path).resolve('dartglass.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);
  connections = new List();
  
  runZoned(() {
    HttpServer.bind('localhost', port).then((server) {
      
      print('listening for connections on $port');
      server.listen((HttpRequest request) {
          if (request.uri.path == '/ws') {
              WebSocketTransformer.upgrade(request).then((WebSocket websocket) {
                connections.add(websocket);
                websocket.listen((message) {                
                  print('received message $message');
                  connections.forEach((ws) => ws.add(message));                               
              });
              // or: websocket.listen(handleMessage);
          });          
        } else {
            staticFiles.serveRequest(request);
        }
      });
    });
    
  },
  onError: (e, stackTrace) => print('Oh noes! $e $stackTrace'));
}
