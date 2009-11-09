/**
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Canvas.fx
 *
 * Created on 7 Nov, 2009, 10:24:29 AM
 */

package javafxfpsmeter;

import javafx.scene.CustomNode;
import javafx.scene.image.Image;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.util.Sequences;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;

/**
 * @author Rakesh Menon
 */

public-read def WIDTH = 600;
public-read def HEIGHT = 400;
public-read def TOTAL_NODES = 6;
public-read def VERTICAL_RADIUS = 90;
public-read def HORIZONTAL_RADIUS = 220;
public-read def SCALE_MIN = 0.5;
public-read def SCALE_MAX = 1.5;
public-read def SPEED = 4;
public-read def FPS = 100;
public-read def SPRINGNESS = 0.2;
public-read def SAMPLE_SIZE = 20;

public-read var count = 0;
public-read var speedCounter = 0.0;
public-read var displayFPS = 0.0;

public class Canvas extends CustomNode {

    def image : Image[] = [
        Image { url: "{__DIR__}images/image0.png" },
        Image { url: "{__DIR__}images/image1.png" },
        Image { url: "{__DIR__}images/image2.png" },
        Image { url: "{__DIR__}images/image3.png" },
        Image { url: "{__DIR__}images/image4.png" },
        Image { url: "{__DIR__}images/image5.png" }
    ];
    
    var thumbnails : Thumbnail[] = [];
    var container = Group { };
    var fpsCount = 0;
    var startTime = java.lang.System.currentTimeMillis();
    
    override function create() : Node {

        var bgRect = Rectangle {
            width: WIDTH
            height: HEIGHT
            fill: Color.WHITE
        };

        addImage();
        addImage();
        addImage();
        
        Group {
            content: [ bgRect, container ]
        }
    }

    override var onMouseClicked = function(me) {
        addImage();
    }
    
    public function addImage() : Void {

        var index = count mod TOTAL_NODES;
        
        var thumbnail = Thumbnail {
            image: image[index]
        };
        thumbnail.update(index);
        insert thumbnail into thumbnails;

        container.content = Sequences.sort(thumbnails) as Node[];
        count++;
    }
    
    function update() : Void {

        for(i in [0..count-1]) {
            thumbnails[i].update(i);
        }
        
        container.content = Sequences.sort(thumbnails) as Node[];
        
        speedCounter += SPEED;
    }

    public function start() : Void {
        var animation = Timeline {
            repeatCount: Timeline.INDEFINITE
            keyFrames: [
                KeyFrame {
                    time: Duration.valueOf(1000/FPS)
                    canSkip: true
                    action: function() {

                        update();

                        fpsCount++;
                        if(fpsCount > SAMPLE_SIZE) {
                            var fps = fpsCount / ((java.lang.System.currentTimeMillis() - startTime) / 1000.0 ) ;
                            fpsCount = 0;
                            startTime = java.lang.System.currentTimeMillis();
                            displayFPS += (fps - displayFPS) * SPRINGNESS;
                        }
                    }
                }
            ]
        };
        animation.play();
    }
}
