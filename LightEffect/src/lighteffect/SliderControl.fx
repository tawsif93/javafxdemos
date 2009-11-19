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
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.layout.LayoutInfo;

/**
 * @author Rakesh Menon
 */

public class SliderControl extends CustomNode {

    public var title = "";
    public var maximum = 0;
    public var minimum = 0;
    public var scaleFactor = 1.0;

    var font = Font.font("sansserif", FontWeight.REGULAR, 12);

    public var titleLabel = SwingLabel {
        text: bind title
        foreground: Color.BLACK
        font: font
        layoutInfo: LayoutInfo { width: 150 }
    }

    var slider = SwingSlider {
        maximum: bind maximum
        minimum: bind minimum
        disable: bind disable
    }
    public var value = bind (slider.value / scaleFactor);

    public var valueLabel = SwingLabel {
        text: bind "{value}"
        foreground: Color.BLACK
        font: font
    }

    public var default = 0.0 on replace {
        slider.value =
        (default * scaleFactor) as Integer;
    }

    override function create() : Node {
        HBox {
            content: [ titleLabel, slider, valueLabel ]
            spacing: 10
        }
    }
}
