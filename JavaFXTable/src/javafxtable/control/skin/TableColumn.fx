/*
 * TableColumn.fx
 *
 * Created on Mar 18, 2010, 10:37:23 AM
 */

package javafxtable.control.skin;

import javafx.scene.control.ListCell;
import javafx.scene.control.Label;
import javafx.scene.layout.Container;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.Node;
import javafxtable.control.TableView;

/**
 * @author Rakesh Menon
 */

public def TABLE_HEADER_HEIGHT = 25.0;

public class TableColumn extends Container {

    public-init var tableView : TableView;
    public-init var index : Integer;
    public-init var name : String = "Column";
    public var columnWidth = 0.0;

    public var onVScrollVisibleChange : function (visible : Boolean);
    public var onVScrollMinChange : function (value : Float);
    public var onVScrollMaxChange : function (value : Float);
    public var onVScrollValueChange : function (value : Float);
    public var onVScrollVisibleAmountChange : function (value : Float);

    public var items : Object[];

    def tableColumnView = TableColumnView {
        items: bind items
        cellFactory: cellFactory
        focusTraversable: false
        onVScrollVisibleChange: bind onVScrollVisibleChange
        onVScrollMinChange: bind onVScrollMinChange
        onVScrollMaxChange: bind onVScrollMaxChange
        onVScrollValueChange: bind onVScrollValueChange
        onVScrollVisibleAmountChange: bind onVScrollVisibleAmountChange
    }
    
    def selectedIndex = bind tableColumnView.selectedIndex on replace {
        tableView.onSelect(selectedIndex);
    }

    /**
     * @treatasprivate
     */
    public function onSelect(index : Integer) : Void {
        tableColumnView.select(index);
        tableColumnView.focus(index);
    }
    
    def header = TableHeader {
        text: bind name
        tableColumn: this
    }

    override var layoutInfo = LayoutInfo {
        width: bind width
        height: bind height
    };

    init {
        content = [ tableColumnView, header ];
    }

    function cellFactory() : ListCell {

        /**
         * This label is used if the item associated with this cell is to be
         * represented as a String. While we will lazily instantiate it
         * we never clear it, being more afraid of object churn than a minor
         * "leak" (which will not become a "major" leak).
         */
        var label:Label;
        def cell:ListCell = ListCell {

            onUpdate: function() {
                def item = cell.item;
                if (item == null) {
                    cell.node = null;
                } else if (item instanceof Node) {
                    cell.node = item as Node;
                } else {
                    if (label == null) {
                        label = Label { }
                    }
                    label.text = "{tableView.tableModel.getValueAt(cell.index, index)}";
                    if (cell.node != label) cell.node = label;
                }
            }
        }
    }

    public function updateVScrollValue(value : Float) : Void {
        tableColumnView.updateVScrollValue(value);
    }

    override function doLayout() : Void {
        layoutNode(header, 0, 0, width, TABLE_HEADER_HEIGHT);
        layoutNode(tableColumnView, 0, TABLE_HEADER_HEIGHT,
            width, (height - TABLE_HEADER_HEIGHT));
    }

    /**
     * @treatasprivate
     */
    public function scrollPageUp():Void {
        tableColumnView.onScrollPageUp();
    }

    /**
     * @treatasprivate
     */
    public function scrollPageDown():Void {
        tableColumnView.onScrollPageDown();
    }

    /**
     * @treatasprivate
     */
    public function selectFirstRow():Void {
        tableColumnView.selectFirstRow();
        tableColumnView.onSelectFirstRow();
    }

    /**
     * @treatasprivate
     */
    public function selectLastRow():Void {
        tableColumnView.selectLastRow();
        tableColumnView.onSelectLastRow();
    }

    /**
     * @treatasprivate
     */
    public function selectPreviousRow():Void {
        tableColumnView.selectPreviousRow();
        tableColumnView.onSelectPreviousRow();
    }

    /**
     * @treatasprivate
     */
    public function selectNextRow():Void {
        tableColumnView.selectNextRow();
        tableColumnView.onSelectNextRow();
    }

    /**
     * @treatasprivate
     */
    public function clearSelection():Void {
        tableColumnView.clearSelection();
    }
}
