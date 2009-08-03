/*
 * SearchView.fx
 *
 * Created on 1 Aug, 2009, 8:20:44 AM
 */

package javafxyt.view;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.control.TextBox;
import javafx.scene.image.Image;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.HBox;
import javafxyt.view.ImageButton;
import javafx.geometry.VPos;

/**
 * @author Rakesh Menon
 */

public class SearchView extends CustomNode {

    public var tag = bind searchText.rawText;
    public var action : function();
    
    var searchText = TextBox {
        text: "javafx"
        promptText: "Search"
        layoutInfo: LayoutInfo {
            width: 80
            height: 24
            vpos: VPos.CENTER
        }
        action: action
    }

    var searchButton = ImageButton {
        normalImage: Image { url: "{__DIR__}images/SearchNormal.png" }
        hotImage: Image { url: "{__DIR__}images/SearchHot.png" }
        pressedImage: Image { url: "{__DIR__}images/SearchPressed.png" }
        action: action
    }
    
    override function create() : Node {
        HBox {
            spacing: 5
            content: [ searchText, searchButton ]
        }
    }
}
