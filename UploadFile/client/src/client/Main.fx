
/*
 * Main.fx
 *
 * Created on 17 Jun, 2009, 9:08:36 AM
 */

package client;

import javafx.io.http.HttpRequest;
import javafx.io.http.HttpHeader;
import javafx.io.http.URLConverter;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;
import javafx.geometry.VPos;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;


/**
 * @author Rakesh Menon
 */

def uploadServletURL = "http://localhost:8080/server/UploadServlet";
def urlConverter = URLConverter{ };

var totalBytes = 1;
var bytesWritten = 0;

function uploadFile(inputFile : java.io.File) {

    totalBytes = inputFile.length();
    bytesWritten = 1;
    
    println("To-Upload - {totalBytes}");
    
    def httpRequest: HttpRequest = HttpRequest {

        location: urlConverter.encodeURL("{uploadServletURL}?file={inputFile.getName()}")
        
        source: new java.io.FileInputStream(inputFile)
        method: HttpRequest.POST

        headers: [
            HttpHeader {
                name: HttpHeader.CONTENT_TYPE
                value: "multipart/form-data"
            }
        ]

        onStarted: function() { println("onStarted"); }
        onConnecting: function() { println("onConnecting") }
        onDoneConnect: function() { println("onDoneConnect") }
        onReadingHeaders: function() { println("onReadingHeaders") }
        onResponseCode: function(code : Integer) { println("onResponseCode - {code}") }
        onResponseMessage: function(msg : String) { println("onResponseMessage - {msg}") }
        onReading: function() { println("onReading") }
        onToWrite: function(bytes: Long) { println("onToWrite({bytes})"); }

        onWritten: function(bytes: Long) {
            bytesWritten = bytes;
            println("onWritten - {(bytesWritten * 100/(totalBytes))}%");
        }

        onException: function(ex: java.lang.Exception) {
            println("onException - {ex}");
        }

        onDoneWrite: function() { println("onDoneWrite") }
        onDone: function() { 
            println("onDone");
            bytesWritten = totalBytes;
        }
    }

    httpRequest.start();
}

/**
 * Client
 */

var label = Label {
    font : Font { size : 12 }
    text: bind "Uploaded - {bytesWritten * 100/(totalBytes)}%"
    layoutInfo: LayoutInfo { vpos: VPos.CENTER maxWidth: 120 minWidth: 120 width: 120 height: 30 }
}

def jFileChooser = new javax.swing.JFileChooser();
jFileChooser.setApproveButtonText("Upload");

var button = Button {
    text: "Upload"
    layoutInfo: LayoutInfo { width: 100 height: 30 }
    action: function() {
        var outputFile = jFileChooser.showOpenDialog(null);
        if(outputFile == javax.swing.JFileChooser.APPROVE_OPTION) {
            uploadFile(jFileChooser.getSelectedFile());
        }
    }
}

var hBox = HBox {
    spacing: 10
    content: [ label, button ]
}

var progressBar = ProgressBar {
    progress: bind (bytesWritten/((totalBytes) as Number))
    layoutInfo: LayoutInfo { width: 240 height: 30 }
}

var vBox = VBox {
    spacing: 10
    content: [ hBox, progressBar ]
    layoutX: 10
    layoutY: 10
}

Stage {
    title: "Upload File"
    width: 270
    height: 120
    scene: Scene {
        content: [ vBox ]
    }
    resizable: false
}
