/*
 * EmbossText.fx
 *
 * Created on 18 Nov, 2009, 10:36:42 AM
 */

package texteffect;

import javafx.scene.CustomNode;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.Group;
import javafx.scene.Node;

/**
 * @author Rakesh Menon
 */

public class EmbossText extends CustomNode {

    public var content : String;
    public var font: Font = Font { name: "sansserif" size: 20 };
    public var width = 300;
    public var height = 150;
    public var fill: Color = Color.GRAY;
    public var darkShadowFill: Color = Color.BLACK;
    public var liteShadowFill: Color = Color.WHITE;

    def text : Text = Text {
        layoutX: bind (width - text.layoutBounds.width)/2.0
        layoutY: bind (height - text.layoutBounds.height)/2.0
        content: bind content
        font: bind font
        fill: bind fill
        textOrigin: TextOrigin.TOP
        opacity: 0.5
    }

    def liteShadowText : Text = Text {
        layoutX: bind (width - text.layoutBounds.width)/2.0
        layoutY: bind (height - text.layoutBounds.height)/2.0 - 1
        content: bind content
        font: bind font
        fill: bind liteShadowFill
        textOrigin: TextOrigin.TOP
        opacity: 0.5
    }

    def darkShadowText : Text = Text {
        layoutX: bind (width - text.layoutBounds.width)/2.0
        layoutY: bind (height - text.layoutBounds.height)/2.0 + 1
        content: bind content
        font: bind font
        fill: bind darkShadowFill
        textOrigin: TextOrigin.TOP
        opacity: 0.5
    }

    override function create() : Node {
        Group {
            content: [ darkShadowText, liteShadowText, text ]
        }
    }
}
