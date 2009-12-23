/*
 * FXTable.fx
 *
 * Created on Dec 22, 2009, 12:18:44 PM
 */

package javafxdatabase.view;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.Group;
import javafx.scene.layout.Panel;
import javafx.scene.control.ScrollBar;
import javafx.scene.layout.ClipView;
import javafx.scene.layout.Resizable;
import javafx.scene.input.KeyCode;
import javafx.util.Math;
import javafx.util.Sequences;
import javafxdatabase.modal.Customer;
import javafxdatabase.Main;

/**
 * @author Rakesh Menon
 */

public class CustomerTable extends CustomNode, Resizable {
    
    def columnName : String[] = [
        "ID", "Name", "City", "State", "Phone", "CL"
    ];
    def columnWidth : Number[] = [
        50, 180, 120, 40, 100, 80
    ];
    def rowHeight = 20.0;

    def columnCount = bind sizeof columnName;

    public var selectedIndex = -1 on replace {
        if((columnCount > 0) and (selectedIndex >= 0)) {
            setSelectedIndex(selectedIndex);
        }
    }
    
    public-read var customerList : Customer[] = [];

    def panel : Panel = Panel {
        layoutX: 1
        layoutY: 1
        onLayout: onLayout
    }
    def panelClipView = ClipView {
        node: panel
        width: bind background.width
        height: bind background.height
        clipX: bind hScroll.value
        clipY: bind vScroll.value
        pannable: false
    }

    def background : Rectangle = Rectangle {
        width: bind width
        height: bind height
        fill: Color.DARKGRAY
    }
    
    def vScroll:ScrollBar = ScrollBar {
        vertical: true
        layoutX: bind background.width
        height: bind height
        max: bind Math.max(panel.boundsInLocal.height - background.height, 1)
    }

    def hScroll:ScrollBar = ScrollBar {
        vertical: false
        layoutY: bind background.height
        width: bind width
        max: bind Math.max(panel.boundsInLocal.width - background.width, 1)
    }

    override function create() : Node {

        addHeader();
        
        Group {
            content: [
                background, panelClipView, hScroll, vScroll
            ]
        };
    }

    function onLayout() : Void {

        var col = 0;
        var row = 0;
        var colX = 0.0;

        for(cell in panel.content) {

            cell.layoutX = colX;
            cell.layoutY = (rowHeight + 1) * row;
            (cell as Cell).width = columnWidth[col];
            (cell as Cell).height = rowHeight;

            colX += columnWidth[col] + 1;
            col++;
            
            if(col >= columnCount) {
                col = 0;
                colX = 0;
                row++;
            }
        }
    }

    override var onMousePressed = function(e) {
        
        requestFocus();

        if(e.source.parent.parent instanceof Cell) {
            var cell = (e.source.parent.parent) as Cell;
            var index = Sequences.indexOf(panel.content, cell)/columnCount;
            if(index >= 0) { selectedIndex = index - 1; }
        }
    }

    override var onMouseClicked = function(e) {
        if(e.clickCount >= 2) {
            Main.inputForm.customer = null;
            Main.inputForm.customer = customerList[selectedIndex];
            Main.inputForm.edit = true;
            Main.inputFormWindow.title = "Customer - Edit";
            Main.inputFormWindow.visible = true;
        }
    }

    override var onKeyPressed = function(e) {
        if(e.code == KeyCode.VK_UP) {
            var index = selectedIndex - 1;
            if(index >= 0) {
                selectedIndex = index;
            }
        } else if(e.code == KeyCode.VK_DOWN) {
            var index = selectedIndex + 1;
            if(index < ((sizeof (panel.content)/columnCount) - 1)) {
                selectedIndex = index;
            }
        }
    }

    function setSelectedIndex(index : Integer) : Void {

        for(node in panel.content) {
            (node as Cell).selected = false;
        }

        var arrayIndex = (index + 1) * columnCount;
        for(i in [arrayIndex..(arrayIndex + columnCount - 1)]) {
            (panel.content[i] as Cell).selected = true;
        }
    }

    function addHeader() {
        for(header in columnName) {
            insert HeaderCell {
                text: "{header}"
            } into panel.content;
        }
    }
    
    public function addRow(customer : Customer) : Void {
        insert Cell { text: "{customer.getCustomerID()}"  } into panel.content;
        insert Cell { text: "{customer.getName()}"        } into panel.content;
        insert Cell { text: "{customer.getCity()}"        } into panel.content;
        insert Cell { text: "{customer.getState()}"       } into panel.content;
        insert Cell { text: "{customer.getPhone()}"       } into panel.content;
        insert Cell { text: "{customer.getCreditLimit()}" } into panel.content;
        insert customer into customerList;
    }

    public function setRow(customer : Customer, index: Integer) : Void {

        var startIndex = ((index + 1) * columnCount) - 1;

        insert Cell { text: "{customer.getCustomerID()}"  } after panel.content[startIndex];
        insert Cell { text: "{customer.getName()}"        } after panel.content[startIndex + 1];
        insert Cell { text: "{customer.getCity()}"        } after panel.content[startIndex + 2];
        insert Cell { text: "{customer.getState()}"       } after panel.content[startIndex + 3];
        insert Cell { text: "{customer.getPhone()}"       } after panel.content[startIndex + 4];
        insert Cell { text: "{customer.getCreditLimit()}" } after panel.content[startIndex + 5];

        insert customer before customerList[index];

        deleteRow(index + 1);

        selectedIndex = -1;
        selectedIndex = index;
    }
    
    public function clear() : Void {
        delete customerList;
        delete panel.content;
        selectedIndex = -1;
        addHeader();
    }

    public function deleteRow(index : Integer) : Void {

        if(index < 0) { return; }

        var startIndex = (columnCount * (index + 1));
        for(i in [startIndex..(startIndex + columnCount - 1)]) {
            delete panel.content[startIndex];
        }
        delete customerList[index];
        
        if(index == selectedIndex) {
            selectedIndex = -1;
        }
    }
    
    override function getPrefHeight(w: Number) {
        if(height <= 0) { return 300; } return height;
    }

    override function getPrefWidth(h: Number) {
        if(width <= 0) { return 300; } return width;
    }
}
