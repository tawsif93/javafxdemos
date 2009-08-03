/*
 * ImageButton.fx
 *
 * Created on 31 Jul, 2009, 3:41:38 PM
 */

package javafxyt.view;

import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Cursor;

/**
 * @author Rakesh Menon
 */

public class ImageButton extends ImageView { 

    public var action : function();
    
    public var normalImage: Image on replace {
        if(normalImage != null) { 
            image = normalImage;
        }
    }

    public var hotImage: Image;
    public var pressedImage: Image;

    init {
        cursor = Cursor.HAND;
    }

    override var onMouseEntered = function(e) {
        if(hotImage != null) {
            image = hotImage;
        }
    }

    override var onMousePressed = function(e) {
        if(pressedImage != null) {
            image = pressedImage;
        }
    }

    override var onMouseReleased = function(e) {

        if(hover) {
            image = hotImage;
        } else {
            image = normalImage;
        }

        if(action != null) {
            action();
        }
    }

    override var onMouseExited = function(e) {
        image = normalImage;
    }
}
