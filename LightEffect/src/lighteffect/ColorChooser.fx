   /*
* ColorChooser.fx
 *
 * Created on 26 Feb, 2009, 9:14:48 PM
 */

package lighteffect;

import javafx.scene.Cursor;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

/**
 * @author Rakesh Menon
 */

public class ColorChooser extends CustomNode {

    public var color: Color = Color.WHITE;
    public var colorDef: String = "#FFFFFF";

    var bgRect = Rectangle {
        width: 83
        height: 444
    };

    function createRectangle( colorID : String ) {

        var rectangle = Rectangle {
            id: colorID
            width: 10
            height: 10
            stroke: Color.TRANSPARENT
            fill: Color.web(colorID)
            cursor: Cursor.HAND
            onMousePressed: function(e) {
                color = (e.node as Rectangle).fill as Color;
                colorDef = e.node.id;
            }
        };
    }

    override function create() : Node {

        var hexColor = [ "00", "33", "66", "99", "CC", "FF" ];

        var row = 0;
        var column = 0;

        var grid = VBox {
            translateX: 5
            translateY: 5
        };

        var hBox: HBox[];
        insert
        HBox {
        } into hBox;

        for(b in hexColor) {
            for(r in hexColor) {
                for(g in hexColor) {

                    if(column == 36) {
                        insert hBox[row] into grid.content;
                        insert
                        HBox {
                        } into hBox;
                        row++;
                        column = 0;
                    }

                    insert createRectangle("#{r}{g}{b}") into hBox[row].content;
                    column++;
                }
            }
        }

        insert
        HBox {
            content: [
                createRectangle("#000000"),
                createRectangle("#111111"),
                createRectangle("#222222"),
                createRectangle("#333333"),
                createRectangle("#444444"),
                createRectangle("#555555"),
                createRectangle("#666666"),
                createRectangle("#777777"),
                createRectangle("#888888"),
                createRectangle("#A0A0A0"),
                createRectangle("#ACACAC"),
                createRectangle("#AAAAAA"),
                createRectangle("#AFAFAF"),
                createRectangle("#B0B0B0"),
                createRectangle("#BCBCBC"),
                createRectangle("#BBBBBB"),
                createRectangle("#BFBFBF"),
                createRectangle("#C0C0C0"),
                createRectangle("#CCCCCC"),
                createRectangle("#CCCCCC"),
                createRectangle("#CFCFCF"),
                createRectangle("#D0D0D0"),
                createRectangle("#DCDCDC"),
                createRectangle("#DDDDDD"),
                createRectangle("#DFDFDF"),
                createRectangle("#E0E0E0"),
                createRectangle("#ECECEC"),
                createRectangle("#EEEEEE"),
                createRectangle("#EFEFEF"),
                createRectangle("#F0F0F0"),
                createRectangle("#FAFAFA"),
                createRectangle("#FBFBFB"),
                createRectangle("#FCFCFC"),
                createRectangle("#FDFDFD"),
                createRectangle("#FEFEFE"),
                createRectangle("#FFFFFF")
            ]
        } into grid.content;

        Group {
            content: [ bgRect, grid ]
        }
    }
}
