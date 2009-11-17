   /*
 * SliderControl.fx
 *
 * Created on 16 Mar, 2009, 2:27:42 PM
 */

package lighteffect;

import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingSlider;
import javafx.scene.CustomNode;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;

/**
 * @author Rakesh Menon
 */

public class SliderControl extends CustomNode {

    public var title = "";
    public var maximum = 0;
    public var minimum = 0;
    public var scaleFactor = 1.0;

    var font = Font.font(null, FontWeight.BOLD, 12);

    public var titleLabel = SwingLabel {
        translateY: 3
        text: bind title
        foreground: Color.WHITE
        font: font
    }

    var slider = SwingSlider {
        width: 100
        maximum: bind maximum
        minimum: bind minimum
        disable: bind disable
    }
    public var value = bind (slider.value / scaleFactor);

    public var valueLabel = SwingLabel {
        text: bind "{value}"
        translateY: 3
        foreground: Color.WHITE
        font: font
        width: 50
    }

    public var default = 0.0 on replace {
        slider.value =
        (default * scaleFactor) as Integer;
    }

    override function create() : Node {
        VBox {
            content: [
                titleLabel,
                HBox {
                    content: [
                        slider, valueLabel
                    ]
                    spacing: 10
                }
            ]
        }
    }
}
