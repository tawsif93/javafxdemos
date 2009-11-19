/*
 * EmbossText.fx
 *
 * Created on 18 Nov, 2009, 11:41:52 AM
 */

package texteffect;

import javafx.scene.effect.Lighting;
import javafx.scene.effect.light.SpotLight;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.CustomNode;
import javafx.scene.Node;

/**
 * @author Rakesh Menon
 */

public class LightText extends CustomNode {
    
    public var content : String;
    public var font: Font = Font { name: "sansserif" size: 20 };
    public var width = 300;
    public var height = 150;
    public var fill: Color = Color.GRAY;
    
    def text : Text = Text {
        layoutX: bind (width - text.layoutBounds.width)/2.0
        layoutY: bind (height - text.layoutBounds.height)/2.0
        content: bind content
        font: bind font
        fill: bind fill
        textOrigin: TextOrigin.TOP
        effect: Lighting {
            diffuseConstant: 2.0
            specularConstant: 1.0
            specularExponent: 20.0
            surfaceScale: 2.9
            light: SpotLight {
                x: 58.0
                y: 211.0
                z: 100.0
                pointsAtX: 100.0
                pointsAtY: -311.0
                pointsAtZ: -105.0
                color: Color.WHITE
            }
        }
    }

    override function create() : Node {
        text;
    }
}
