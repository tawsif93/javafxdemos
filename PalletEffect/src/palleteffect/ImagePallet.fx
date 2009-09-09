/*
 * ImagePallete.fx
 *
 * Created on 2 Mar, 2009, 9:29:54 AM
 */

package palleteffect;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import javafx.scene.paint.Color;

/**
 * @author Rakesh Menon
 */

def palletColor = [
    Color.rgb(24,17,5), Color.rgb(89,65,13), Color.rgb(59,29,10), Color.rgb(79,26,24), Color.rgb(29,15,14),
    Color.rgb(105,35,32), Color.rgb(14,25,30), Color.rgb(17,31,27), Color.rgb(173,153,21), Color.rgb(57,67,26),
    Color.rgb(23,57,85), Color.rgb(122,53,19), Color.rgb(20,50,74), Color.rgb(2,2,6), Color.rgb(42,39,34),
    Color.rgb(122,53,19)
];

public class ImagePallet extends CustomNode {
    
    public var width = 400;
    public var height = 267;

    override var blocksMouse = true;
    
    var mouseOverNode: ColorNode[];
    var timeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames: [
            KeyFrame {
                time: 40ms
                canSkip: true
                action: function() {
                    updateNodes();
                }
            }
        ]
    };
    
    var row = height / ColorNode.size;
    var column = width / ColorNode.size;
    
    var grid = Group { rotate: 180 };
    var random = new java.util.Random();
    
    function animateNodes(entered : Boolean) {

        hide = not entered;
        delete mouseOverNode;
        
        for(node in grid.content) {
            animateNode(node as ColorNode);
        }

        if(entered) {
            toFront();
        }
    }
    
    function animateNode(colorNode : ColorNode) {
        colorNode.repeatCount = (
        (colorNode.layoutY / (ColorNode.size * 100)) + 2) as Integer;
        colorNode.rate = random.nextInt((colorNode.layoutY  /  ColorNode.size) + 1) + 1;
        colorNode.count = 0;
        colorNode.transparent = hide;
        colorNode.stroke = Color.BLACK;
        insert colorNode into mouseOverNode;
    }
    
    var hide = true;
    function updateNodes() {

        if((sizeof mouseOverNode) <= 0) {
            for(node in grid.content) {
                if(hide) {
                    (node as ColorNode).stroke = Color.BLACK;
                } else {
                    (node as ColorNode).stroke = Color.TRANSPARENT;
                }
            }
            return;
        }
        
        for(colorNode in mouseOverNode) {
            
            if(colorNode.repeatCount <= 1) {
                delete colorNode from mouseOverNode;
                if(hide) {
                    if(colorNode.column > (column - 3)) {
                        if((random.nextInt(10) mod 2) == 0) {
                            colorNode.transparent = true;
                        }
                    }
                }
            } else {
                if(colorNode.count >= colorNode.rate) {
                    colorNode.repeatCount = colorNode.repeatCount - 1;
                    colorNode.transparent = not colorNode.transparent;
                } else {
                    colorNode.count++;
                }
            }
        }
    }

    public var url = "";
    
    var imageView = ImageView {
        image: bind getImage(url)
        fitWidth: bind grid.boundsInLocal.width - 1
        fitHeight: bind grid.boundsInLocal.height - 1
    }
    
    override function create() : Node {

        for(y in [1..row]) {
            for(x in [1..column]) {
                var index = random.nextInt((sizeof palletColor) - 1);
                var colorNode = ColorNode {
                    fill: palletColor[index]
                    row: (y - 1)
                    column: (x - 1)
                };
                if(colorNode.column > (column - 3)) {
                    if((random.nextInt(10) mod 2) == 0) {
                        colorNode.transparent = true;
                    }
                }
                insert colorNode into grid.content;
            }
        }
        
        timeline.play();
        
        Group {
            content: [ imageView, grid ]
        }
    }
    
    override var onMouseEntered = function(e) {
        animateNodes(true);
    }

    override var onMouseExited = function(e) {
        animateNodes(false);
    }
    
    function getImage(imageURL : String) : Image {
        Image {
            url: imageURL
        }
    }
}
