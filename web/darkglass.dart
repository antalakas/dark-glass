import 'dart:html' as html;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "package:google_mirror_v1_api/mirror_v1_api_browser.dart";
import "package:google_mirror_v1_api/mirror_v1_api_client.dart";

final String CLIENT_ID = '826661342379-1rladko7bt5kkhuli67tvkfvvqh8u6ip.apps.googleusercontent.com';
//Pieter-Jan: 826661342379-1rladko7bt5kkhuli67tvkfvvqh8u6ip.apps.googleusercontent.com
//Friedger glass: 6042312500-o1e06j0glcho28qgsgn608t4knvp9r5s.apps.googleusercontent.com
//Andreas: 1094104573644-ocrus19vdkkv26oft9pk3euler8h9hdd.apps.googleusercontent.com
final List<String> SCOPES = [
'https://www.googleapis.com/auth/userinfo.profile',
'https://www.googleapis.com/auth/glass.timeline'
];
//final String API_KEY = 'AIzaSyBfA-Zqg9hVWVBJHLXj0ycQTyB3J0IYyN0';

GoogleOAuth2 auth;
//  <img src="https://www.dartlang.org/imgs/dart-logo.png" height="100%" width="100%">  
//<footer>    
//<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAVCAMAAACeyVWkAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAJxQTFRFAAAAAIvMdsvDAIvMdsvDAIvMdsvDLaTJAIvMOqnHdsvDAIvMdsvDAIvMKaLJdsvDAIvMAIvMdsvDAIvMdsvDdsvDAIvMAIvMAZnFdsvDAILHAIPHAITIAIXJAIfKAIjKAIrLAIrMAIvMAJXHAJjFC5i/I6HENr2yOb6zPr+0TsK4UsO5WbnEWcW8Xsa9Yse+Zsi/asjAc8rCdsvDdt4SRQAAABp0Uk5TABAQICAwMFBgYGBwcICAgI+vr7+/z9/v7+97IXGnAAAAqUlEQVQYV13QxxaCQBBE0VZkjBgAGVEBaVEUM/P//yaTGg5vV3dZANTCZ9BvFAoR93kVC9FnthW6uIPTJ7UkdHaXvS2LXKNBURInyDXPsShbzjU7XCpxhooDVGo5QcQAJmjUco64AY/UcIrowYCTaj5KBZeTaj5JBTc6l11OlQKMf497y1ahefFb3TQfcqtM/fipJF/X9gnDon6/ah/aDDfNOgosNA2b8QdGciZlh/U93AAAAABJRU5ErkJggg==" class="left">  
//<p>Dart Hacking</p>   
//</footer> 

//<article class="auto-paginate">  
//  <ol class="text-x-small">  
//  <strong>Instructions:</strong>
//  <hr>  
//    <li>First item</li>    
//    <li>Second item</li>    
//    <li>Third item</li>    
//    <li>Fourth item</li>  
//  </ol>
//</article>


//<footer>    
//<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAVCAMAAACeyVWkAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAJxQTFRFAAAAAIvMdsvDAIvMdsvDAIvMdsvDLaTJAIvMOqnHdsvDAIvMdsvDAIvMKaLJdsvDAIvMAIvMdsvDAIvMdsvDdsvDAIvMAIvMAZnFdsvDAILHAIPHAITIAIXJAIfKAIjKAIrLAIrMAIvMAJXHAJjFC5i/I6HENr2yOb6zPr+0TsK4UsO5WbnEWcW8Xsa9Yse+Zsi/asjAc8rCdsvDdt4SRQAAABp0Uk5TABAQICAwMFBgYGBwcICAgI+vr7+/z9/v7+97IXGnAAAAqUlEQVQYV13QxxaCQBBE0VZkjBgAGVEBaVEUM/P//yaTGg5vV3dZANTCZ9BvFAoR93kVC9FnthW6uIPTJ7UkdHaXvS2LXKNBURInyDXPsShbzjU7XCpxhooDVGo5QcQAJmjUco64AY/UcIrowYCTaj5KBZeTaj5JBTc6l11OlQKMf497y1ahefFb3TQfcqtM/fipJF/X9gnDon6/ah/aDDfNOgosNA2b8QdGciZlh/U93AAAAABJRU5ErkJggg==" class="left">    
//</footer> 

html.ImageElement img;


final String timeLinehtml = """
<article class="photo">  

   <img src="${img.src}" class="left"  width="100%" height="100%">

<div class="overlay-gradient-tall-dark"/>
  <section>    
    <p class="text-auto-size">
      <strong class="white">This is you, via</strong> 
      <em class="blue">Dark Glass Selfie!</em>
    </p>  
  </section>

</article>
""";

void insertCard() {
  Mirror mirror = new Mirror(auth);
  mirror.makeAuthRequests = true;

  NotificationConfig notification = new NotificationConfig.fromJson({})
  ..level = "DEFAULT";

  MenuItem menuItem = new MenuItem.fromJson({})
  ..action = "VIEW_WEBSITE"
  ..payload = "http://www.google.com";

  TimelineItem timeLineItem = new TimelineItem.fromJson({})
  ..menuItems = [menuItem]
  ..html = timeLinehtml
  ..notification = notification;

  mirror.timeline.insert(timeLineItem)
  .then((TimelineItem updatedItem) =>
      html.querySelector("#output").text = updatedItem.toString(),
      onError: (error) => html.querySelector("#output").text = error);
}

bool isStreaming = false;

void screenshotButtonClick(ev) {
  if (isStreaming)
  {
    img = html.document.querySelector('#screenshot');
    html.CanvasElement canvas = html.document.querySelector('#screenshot-canvas');
    var ctx = canvas.getContext('2d');
    
    html.VideoElement screenshotStream = 
        html.querySelector("#screenshot-stream");
    
    ctx.drawImage(screenshotStream, 0, 0);
    img.src = canvas.toDataUrl('image/webp');
  }
  else
  {
    html.window.navigator.getUserMedia(video: true)
      .then((stream) {
        
        html.VideoElement screenshotStream = 
            html.querySelector("#screenshot-stream");
        
        screenshotStream.autoplay = true;
        screenshotStream.src = html.Url.createObjectUrl(stream);
        
        html.ButtonElement screenshotButton = html.querySelector("#screenshot-button");
        screenshotButton.text = 'Take Shot';
        
        isStreaming = true;
        
//      var video = new html.VideoElement()
//      ..autoplay = true
//      ..src = html.Url.createObjectUrl(stream)
//      ..onLoadedMetadata.listen((e) => print(e));
//      html.document.body.append(video);
      });
  }
  

}

void signInDone(Token token){
  signedIn = true;
}

int signedIn = false;

void main() {
  auth = new GoogleOAuth2(CLIENT_ID, SCOPES);

  var screenshotButton = html.querySelector("#screenshot-button");
  screenshotButton.onClick.listen((ev) => screenshotButtonClick(ev));
  

  print("Attempting to log you in.");
  auth.login().then(signInDone,
      onError: (error) => print("login error: $error"));
   
  html.querySelector("#sign-in").onClick.listen((e) {
    insertCard();
  });

  html.querySelector("#sign-out").onClick.listen((e) {
    auth.logout();
    print("Signing you out.");
  });
}