/* 
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER
 * Copyright 2009 Sun Microsystems, Inc. All rights reserved. Use is subject to license terms. 
 * 
 * This file is available and licensed under the following license:
 * 
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright notice, 
 *     this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *   * Neither the name of Sun Microsystems nor the names of its contributors 
 *     may be used to endorse or promote products derived from this software 
 *     without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package mp3player;

import javafx.animation.Timeline;
import javafx.scene.Cursor;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.effect.Glow;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.media.MediaError;
import javafx.scene.media.MediaPlayer;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.AppletStageExtension;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import javafx.data.feed.rss.Channel;
import javafx.data.feed.rss.Item;
import javafx.data.feed.rss.RssTask;
import javafx.scene.layout.VBox;
import javafx.io.http.URLConverter;
import javafx.scene.text.TextOrigin;
import javafx.ext.swing.SwingComponent;
import javax.swing.JTextField;
import java.awt.event.ActionListener;
import javafx.io.Storage;
import java.io.BufferedReader;
import java.io.InputStreamReader;

var stage:Stage;

var isApplet = "true".equals(FX.getArgument("isApplet") as String);
var inBrowser = isApplet;
var draggable = AppletStageExtension.appletDragSupported;

var homePage = "http://javafx.com/samples/DraggableMP3Player/index.html";

/**
 * JavaFX-Storage: Save last searched artist name
 */
function store(artist : String) : Void {

    try {
        
        var entry = Storage {
            source: "MP3Player.dat"
        };
        var out = entry.resource.openOutputStream(true);
        out.write(artist.getBytes());
        out.close();
        
    } catch (e : java.lang.Exception) { }
}

function load() : String {

    var artist = "Michael Jackson";

    try {
        
        var entry = Storage {
            source: "MP3Player.dat"
        };
        var in = entry.resource.openInputStream();
        var reader = new BufferedReader(new InputStreamReader(in));
        var line = reader.readLine();
        if(line != null) { artist = line; }
        in.close();
        
    } catch (e : java.lang.Exception) { }

    return artist;
}

var artist = Text {
    translateY: 45
    translateX: 170
    font: Font { size: 12 }
    content: "Artist: "
    textOrigin: TextOrigin.TOP
}

var defaultArtist = load();
var artistTextField = new JTextField(defaultArtist);
artistTextField.setBorder(null);
artistTextField.setBackground(new java.awt.Color(0,0,0,0));
artistTextField.addActionListener(ActionListener {
    override function actionPerformed(ae) {
        startRssTask();
    }
});
var artistText = SwingComponent.wrap(artistTextField);
artistText.translateY = 42;
artistText.translateX = 175 + artist.layoutBounds.width;
artistText.width = 360 - artist.layoutBounds.width;

def playlist = Playlist {  };
var rssTask : RssTask;

function startRssTask() : Void {

    rssTask.stop();
    stopCurrentSong();
    store(artistTextField.getText());
    
    rssTask = RssTask {

        location: "http://developer.echonest.com/artist/{URLConverter{ }.encodeString(artistTextField.getText())}/audio.rss"
        interval: 1h

        onChannel: function(channel : Channel) {
            playlist.clear();
        }

        /**
         * <item>
         * <title>Trailer Trash</title>
         * <link>http://media.libsyn.com/media/mikewentwest/08_Trailer_Trash.mp3</link>
         * <description>Trailer Trash by Modest Mouse, found at http://www.mikewentwest.com</description>
         * <dc:creator xmlns:dc="http://purl.org/dc/elements/1.1/">Gathered by The Echo Nest</dc:creator>
         * <pubDate>Wed, 14 Oct 2009 04:33:00 +0000</pubDate>
         * <guid>http://media.libsyn.com/media/mikewentwest/08_Trailer_Trash.mp3</guid>
         * <enclosure url="http://media.libsyn.com/media/mikewentwest/08_Trailer_Trash.mp3" length="349" type="audio/mpeg"></enclosure>
         * </item>
         */
        onItem: function(item : Item) {
            playlist.add(Song {
                title: trimString(item.title, 40)
                link: item.link
                description: trimString(item.description, 70)
                pubDate: item.pubDate
                guid: item.guid.text
            });
        }

        onDone: function() {
            updatePlayList();
            playlist.currentSong = 0;
        }
    }
    rssTask.start();
}

function stopCurrentSong():Void {
    mediaPlayer.stop();
    mediaPlayer.media = null;
    if (playlist.currentPlayingSong != null) {
        playlist.currentPlayingSong.closeMedia();
    }
}

function playCurrentSong():Void {
    playlist.currentPlayingSong = playlist.songs[playlist.currentSong];
    mediaPlayer.media = playlist.currentPlayingSong.getMedia();
    mediaPlayer.play();
}

FX.addShutdownAction(function() { stopCurrentSong(); });

var mediaPlayer:MediaPlayer = MediaPlayer {
    volume: 0.5
    autoPlay: false
    onError: function(e:MediaError) {
        println("MediaPlayer Error: {e.cause} {e}");
        stopCurrentSong();
    }
    onEndOfMedia: function() {
        stopCurrentSong();
        playlist.currentSong++;
        playCurrentSong();
    }
};


var playlist_bg = ImageView { id: "playlist_bg" opacity: 1.0 visible: true
    translateX: 198
    translateY: 120
    image: Image { url: "{__DIR__}images/MP3_handoff_playlist.png" }
};

var song_info_current_song:Song = null;
var song_info_popup:Group = Group {
    visible: false
    translateX: 250
    translateY: 40
    blocksMouse: true
    content: [
        Rectangle {
            width: 220 height: 290
            fill: Color.BLACK
            arcWidth: 20
            arcHeight: 20
            stroke: Color.rgb(50,50,50)
            cursor: Cursor.HAND
            onMouseClicked: function(me) {
                AppletStageExtension.showDocument(song_info_current_song.link);
                song_info_popup.visible = false;
            }
        },
        ImageView { x: 5 y: 5 image: Image { url: "{__DIR__}images/MP3_handoff_drag_close.png" }
            blocksMouse: true
            onMousePressed: function(e) {
                song_info_popup.visible = false;
            }
        },
        VBox {
            translateX: 10
            translateY: 40
            spacing: 10
            content: [
                Text { font: Font { size: 15 } content: bind song_info_current_song.title fill: Color.WHITE wrappingWidth: 200 },
                Text { font: Font { size: 12 } content: bind song_info_current_song.link fill: Color.WHITE wrappingWidth: 200 underline: true },
                Text { font: Font { size: 10 } content: bind song_info_current_song.description fill: Color.WHITE wrappingWidth: 200 }
            ]
        }
    ]
}

var playlist_text = Group { };
function updatePlayList() : Void {
    
    delete playlist_text.content;
    
    for(song in playlist.songs) {

        if(indexof song > 11) {
            break;
        }

        var i_image = ImageView { x: 357 image: Image { url: "{__DIR__}images/MP3_handoff_i.png" } };
        var i_overlay_image = ImageView { x: 353 y:-2 opacity: 0.0 image: Image { url: "{__DIR__}images/MP3_handoff_Group_1_copy_2.png" }
            onMouseClicked: function(e) {
                song_info_current_song = song;
                song_info_popup.visible = true;
            }
        };
        RolloverBehavior { target: i_overlay_image };

        insert Group {
            translateX: 210
            translateY: 15 * indexof song + 190
            content: [
                ImageView {
                    x: 0
                    visible: bind (playlist.currentSong == indexof song)
                    image: Image { url: "{__DIR__}images/MP3_handoff_playlist_volume.png" }
                },
                Text {
                    x: 20
                    y: 8
                    fill: Color.WHITE
                    content: "{1 + indexof song}  {song.title}"
                    font: Font { size: 11 name: "Arial" }
                },
                i_image,
                i_overlay_image,
            ]
        } into playlist_text.content;
    }
}


var playlist_innerGroup = Group {
    translateY: -230
    content: [playlist_bg,  playlist_text]
};
var playlist_group = Group {
    content: playlist_innerGroup
    clip: Rectangle { x: 200 y: 100 width: 400 height: 300 }
};

var playlist_reveal = Timeline {
    rate: -1.0
    keyFrames: [
        at (0s)   { playlist_innerGroup.translateY => -230 },
        at (0.4s) { playlist_innerGroup.translateY => 0 }
    ]
};


// the body of the player
var player_normal = ImageView { id: "player_normal"
    opacity: 1.0  visible: true
    x: 83 y: 29
    image: Image { url: "{__DIR__}images/MP3_handoff_player_normal.png" },
};




// the various button rollovers
var fx_rollover:ImageView = ImageView { id: "fx_rollover"
    opacity: 0.0 visible: true
    x: 196 y: 91
    image: Image { url: "{__DIR__}images/MP3_handoff_fx_rollover.png" },
    onMouseClicked: function(e) {
        AppletStageExtension.showDocument(homePage);
    }
};
RolloverBehavior { target: fx_rollover };

var playlist_rollover:ImageView = ImageView { id: "playlist_rollover"
    opacity: 0.0 visible: true
    x: 115 y: 157
    blocksMouse:true
    image: Image { url: "{__DIR__}images/MP3_handoff_playlist_rollover.png" },
    onMousePressed: function(e) {
        playlist_reveal.rate *= -1.0;
        playlist_reveal.play();
    }
};
RolloverBehavior { target: playlist_rollover };


var playBack = ImageView { id: "playBack"
    opacity: 0.0 visible: true
    x: 99 y: 104
    image: Image { url: "{__DIR__}images/MP3_handoff_playBack.png" },
    onMousePressed: function(e) {
        var paused = mediaPlayer.paused;
        if (not paused) {
            stopCurrentSong();
            playlist.currentSong--;
            playCurrentSong();
        } else {
            playlist.currentSong--;
        }
    }
};
RolloverBehavior { target: playBack };


var playForward = ImageView { id: "playFoward"
    opacity: 0.0 visible: true
    x: 165 y: 107
    image: Image { url: "{__DIR__}images/MP3_handoff_playFoward.png" },
    onMousePressed: function(e) {
        var paused = mediaPlayer.paused;
        if (not paused) {
            stopCurrentSong();
            playlist.currentSong++;
            playCurrentSong();
        } else {
            playlist.currentSong++;
        }
    }
};
RolloverBehavior { target: playForward };


var stop = ImageView { id: "stop"
    opacity: 0.0 visible: true
    x: 116 y: 88
    image: Image { url: "{__DIR__}images/MP3_handoff_stop.png" },
    onMousePressed: function(e) {
        mediaPlayer.stop();
    }
};
RolloverBehavior { target: stop };


var play_normal_image = Image { url: "{__DIR__}images/play.png" };
var play_rollover_image = Image { url: "{__DIR__}images/play_selected.png" };
var pause_normal_image = Image { url: "{__DIR__}images/pause.png" };
var pause_rollover_image = Image { url: "{__DIR__}images/pause_selected.png" };
var play_rollover:ImageView = ImageView { id: "play_rollover"
    opacity: 1.0 visible: true
    x: 122 y: 114
    image: bind if (not mediaPlayer.paused) {
        if (play_rollover.hover) { pause_rollover_image } else { pause_normal_image }
    } else {
        if (play_rollover.hover) { play_rollover_image } else { play_normal_image }
    }
    onMousePressed: function(e) {
        if (playlist.currentPlayingSong != playlist.songs[playlist.currentSong]) {
            stopCurrentSong();
            playCurrentSong();
        } else {
            if (mediaPlayer.paused) {
                mediaPlayer.play();
            } else {
                mediaPlayer.pause();
            }
        }
    }
};

var drag_close_rollover = Image { url: "{__DIR__}images/close_rollover.png" };
var drag_close_normal = Image { url: "{__DIR__}images/close.png" };
var drag_out_rollover = Image { url: "{__DIR__}images/dragOut_rollover.png" };
var drag_out_normal = Image { url: "{__DIR__}images/dragOut.png" };

var drag_closers = Group {
    content:[ 
        ImageView { x: 551 y: 48 image: drag_close_normal  visible: bind not inBrowser },
        ImageView { x: 551 y: 48 image: drag_out_normal  visible: bind inBrowser and draggable  },
        Rectangle { x: 551 y: 48 width: 10 height: 10 fill: Color.TRANSPARENT
            onMouseClicked: function(e:MouseEvent):Void { stage.close(); }
        }
    ]
    };

var dragRect:Rectangle = Rectangle {
    x: 155 y: 30 width: 420 height: 40 fill: Color.TRANSPARENT
};

var stageDragInitialX:Number;
var stageDragInitialY:Number;

var can_drag_me: ImageView = ImageView {
    id: "can_drag_me"
    visible: true
    x: 83
    y: 29
    image: Image { url: "{__DIR__}images/MP3_handoff_can_drag_me.png" },

    onMousePressed: function(e) {
        stageDragInitialX = e.screenX - stage.x;
        stageDragInitialY = e.screenY - stage.y;
    }
    onMouseDragged: function(e) {
        stage.x = e.screenX - stageDragInitialX;
        stage.y = e.screenY - stageDragInitialY;
    }
};

// the time control slider
var time_control_length = 240.0;
var time_control_xoff = 210;
var currentTime = bind
    if (mediaPlayer.media != null and
        mediaPlayer.media.duration != null and
        mediaPlayer.media.duration.toMillis() > 0 and
        mediaPlayer.currentTime.toMillis() > 0)
    {
        time_control_length * mediaPlayer.currentTime.toMillis() / mediaPlayer.media.duration.toMillis()
    } else {
        0.0
    };
var bufferedTime = bind
    if (mediaPlayer.media != null and
        mediaPlayer.media.duration != null and
        mediaPlayer.media.duration.toMillis() > 0 and
        mediaPlayer.bufferProgressTime.toMillis() > 0)
    {
        time_control_length * mediaPlayer.bufferProgressTime.toMillis() / mediaPlayer.media.duration.toMillis()
    } else {
        0.0
    };
var time_control:ImageView = ImageView { id: "time_control"
    cursor: Cursor.HAND
    opacity: 1.0 visible: true
    x: bind currentTime + time_control_xoff  y: 143
    image: Image { url: "{__DIR__}images/MP3_handoff_time_control.png" },
    blocksMouse: true
    onMouseDragged: function(e) {
        if (mediaPlayer.media != null and mediaPlayer.media.duration > 0s) {
            var x = e.x;
            var available = mediaPlayer.bufferProgressTime.toMillis() / mediaPlayer.media.duration.toMillis();
            var xmin = time_control_xoff;
            var xmax = xmin + (available*time_control_length);
            if (x > xmin and x < xmax) {
                var t = (x - xmin) / time_control_length * mediaPlayer.media.duration.toMillis();
                mediaPlayer.currentTime = Duration.valueOf(t);
            }
        }
    }
};

var current_time_indicator = ImageView { id: "current_time_indicator"
    opacity: 1.0 visible: true
    translateX: 214
    translateY: 154
    image: Image { url: "{__DIR__}images/MP3_handoff_blue_play_fill.png" }
    clip: Rectangle { x: 0 y: 0 width: bind currentTime height: 20}
};

var buffering_indicator = Rectangle {
    fill: LinearGradient {
        startX: 0 startY: 0
        endX: 1 endY: 0
        stops: [
            Stop { offset: 0.9 color: Color.rgb(255, 255, 255, 0.1) },
            Stop { offset: 1.0 color: Color.TRANSPARENT }
        ]
    }
    translateX: 216
    translateY: 157
    width: bind bufferedTime
    height: 2
};

function getTimeString(dur:Duration):String {
    if (dur == null or dur < 0s) {
        return "0:00";
    } else {
        var minutes = dur.toMinutes() as Integer;
        var seconds = dur.toSeconds() mod 60 as Integer;
        return "{minutes}:{%02d seconds}";
    }
}

var current_time = Text {
    fill: Color.web("#0d9c0d")
    x: 465 y: 160 font: Font { size: 9 }
    content: bind getTimeString(mediaPlayer.currentTime)
};
var total_time = Text {
    fill: Color.web("#c5c5c5")
    x: 490 y: 160 font: Font { size: 9 }
    content: bind "/ {getTimeString(mediaPlayer.media.duration)}"
};



    
var volume_icon = ImageView {
    id: "volume_icon"
    opacity: 1.0
    x: 542
    y: 150
    image: Image {
        url: "{__DIR__}images/MP3_handoff_volume_icon.png"
    },
};

var volume_group:Group = Group {
    translateY: 110
    content: [
        ImageView { image: Image { url: "{__DIR__}images/MP3_handoff_bkg.png" } 
            blocksMouse: true
            onMouseDragged:function(e) {
                var v = (e.y-14)/65;
                if(v < 0) { v = 0; }
                if(v > 1.0) { v = 1.0; }
                v = 1-v;
                mediaPlayer.volume = v;
            }
        },
        Rectangle { x: 22 y: 16 width: 12 height: 68 
            fill: bind LinearGradient {
                    startX:0 endX: 0 startY: 0 endY: 1 proportional: true
                    stops: [
                        Stop { color: Color.BLACK offset: 0.0 },
                        Stop { color: Color.GREEN offset: 0.99-(mediaPlayer.volume*0.98) },
                        Stop { color: Color.GREEN offset: 1.0 },
                    ]
                }
            },
        ImageView { image: Image { url: "{__DIR__}images/MP3_handoff_outline_inner_shadow.png" } x: 21 y: 15},
        ImageView { image: Image { url: "{__DIR__}images/MP3_handoff_slider.png" } 
            x: 13
            y: bind (1-mediaPlayer.volume) * 65 + 14
        },
    ]
};
var volume_group_wrapper = Group { 
    blocksMouse: true
    translateX: 523
    translateY: 30
    content: volume_group
    clip: Rectangle { width: 100 height: 130 }
};

var reveal_volume = Timeline {
    keyFrames: [ 
        at (0s)   { volume_group.translateY => 110 },
        at (0.3s) { volume_group.translateY => 0 },
    ]
}

var volume_rollover = ImageView {
    id: "volume_rollover"
    opacity: 0.0
    x: 542
    y: 150
    blocksMouse: true
    image: Image {
        url: "{__DIR__}images/MP3_handoff_volume_rollover.png"
    },
    effect: Glow { }
    onMousePressed: function(e) {
        reveal_volume.rate *= -1.0;
        reveal_volume.play();
    }
};
RolloverBehavior { target: volume_rollover };

function createGradient(color:Color) {
    return LinearGradient {
        proportional: false
        startX: 0 startY: 0 endX: 275 endY: 0
        stops: [
            Stop { offset: 0.0 color: color },
            Stop { offset: 0.8 color: color },
            Stop { offset: 1.0 color: Color.TRANSPARENT }
        ]
    }
}

var songInfo = Group {
    translateX: 300
    translateY: 95
    content: [
        Text {
            font: Font { size: 11 }
            content: bind "{playlist.songs[playlist.currentSong].title}"
            x: 0 y: 0 fill: createGradient(Color.WHITE);
        },
        Text {
            font: Font { size: 10 }
            content: bind "{playlist.songs[playlist.currentSong].description}"
            x: 0 y: 15 fill: createGradient(Color.color(0.7, 0.7, 0.7));
            wrappingWidth: 250
        }
    ]
};



stage = Stage {
    title: "MP3 Player"
    visible: true
    style: StageStyle.TRANSPARENT
    scene: Scene {
        width: 510
        height: 345
        fill: bind if (inBrowser) Color.WHITE else Color.TRANSPARENT
        content: Group {
            translateX: -75
            translateY: -25
            content: [
                can_drag_me,
                playlist_group,
                // the player itself
                player_normal,
                // the rollovers
                fx_rollover,
                playlist_rollover,
                playBack,
                playForward,
                stop,
                play_rollover,
                // the time control and labels
                buffering_indicator,
                current_time_indicator,
                time_control,
                current_time,
                total_time,
                // drag controls
                dragRect,
                artist,
                artistText,
                drag_closers,
                // text on the player itself
                songInfo,
                //volume control,
                volume_group_wrapper,
                ImageView { image: Image { url: "{__DIR__}images/MP3_handoff_volume_bkg.png" } x: 491 y: 130 },
                volume_icon,
                volume_rollover,
                // the song info popup
                song_info_popup,
            ]
        }
    }
    extensions: [
        AppletStageExtension {
            shouldDragStart: function(e): Boolean {
                return inBrowser and e.primaryButtonDown and dragRect.hover;
            }
            onDragStarted: function(): Void {
                inBrowser = false;
            }
            onAppletRestored: function(): Void {
                inBrowser = true;
            }
            useDefaultClose: false
        }
    ]
}

// Trim the string if length is greater than specified length
function trimString(string:String, length:Integer) : String {

    if(string == null) return "";

    if(string.length() > length) {
        return "{string.substring(0, length).trim()}...";
    } else {
        return string;
    }
}

startRssTask();
