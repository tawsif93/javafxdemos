function showRSSViewerApplet() { 
    document.getElementById("RSSViewerApplet").innerHTML = "javafx( { archive: http://javafx.com/samples/RSSViewer/webstart/RSSViewer.jar,, width: 610, height: 62, code: rssviewer.Main, name: RSSViewer } , {  isApplet: true,  js_mode: true,  rss_url: http://news.google.com/news?pz=1&ned=us&hl=en&topic=w&output=rss }  );"; 
}
