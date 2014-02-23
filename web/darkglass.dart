import 'dart:html';

//import 'package:google_mirror_v1_api/mirror_v1_api_browser.dart';
//import 'package:google_mirror_v1_api/mirror_v1_api_client.dart';
//import 'package:google_mirror_v1_api/mirror_v1_api_console.dart';

void main() {
  querySelector("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);
}

void reverseText(MouseEvent event) {
  var text = querySelector("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  querySelector("#sample_text_id").text = buffer.toString();
}
