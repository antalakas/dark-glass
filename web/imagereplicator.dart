library imagereplicator;

import 'dart:async' show Future, Timer;
import 'dart:html';

class ImageReplicator {
  WebSocket ws;
  var img;
  
  ImageReplicator.withImage(this.img){
    init();
  }
  
  outputMsg(String msg) {
    var output = querySelector('#output-area');
    var text = msg;
    if (!output.text.isEmpty) {
      text = "${output.text}\n${text}";
    }
    output.text = text;
  }
  
  void init([int retrySeconds = 2]) {
    var reconnectScheduled = false;
  
    outputMsg("Connecting to websocket");
    print('Connecting');
    ws = new WebSocket('ws://localhost:9999/ws');
  
    void scheduleReconnect() {
      if (!reconnectScheduled) {
        new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
      }
      reconnectScheduled = true;
    }
  
    ws.onOpen.listen((e) {
      outputMsg('Connected');      
    });
  
    ws.onClose.listen((e) {
      outputMsg('Websocket closed, retrying in $retrySeconds seconds');
      scheduleReconnect();
    });
  
    ws.onError.listen((e) {
      outputMsg("Error connecting to ws");
      scheduleReconnect();
    });
  
    ws.onMessage.listen((MessageEvent e) {
      img.src  = e.data;
      outputMsg('Received image');
    });
  }
  
  replicate (String image){
    ws.send(image);
  }
}