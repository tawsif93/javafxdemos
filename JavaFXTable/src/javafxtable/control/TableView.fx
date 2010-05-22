/*
 * TableView.fx
 *
 * Created on Mar 15, 2010, 3:28:07 PM
 */

package javafxtable.control;

import javafx.scene.Group;
import javafx.scene.layout.Container;
import javafx.scene.input.KeyCode;
import javafx.scene.control.ScrollBar;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.input.KeyEvent;
import javafx.util.Sequences;
import javafxtable.control.skin.TableColumn;

/**
 * @author Rakesh Menon
 */

public class TableView extends Container, TableModelListener {

    public var tableModel : TableModel on replace {
        tableModel.removeTableModelListener(this);
        tableModel.addTableModelListener(this);
    }

    public-read var selectedRow : Integer;

    var items : String[] = [];

    var rowCount : Integer = 0 on replace {
        var sizeOfItems = (sizeof items);
        if(sizeOfItems < rowCount) {
            for(i in [sizeOfItems..(rowCount - 1)]) {
                insert "" into items;
            }
        } else if(sizeOfItems > rowCount) {
            for(i in [rowCount..(sizeOfItems - 1)]) {
                delete items[i] from items;
            }
        }
    }

    def group = Group { }
    public-read var tableColumns : TableColumn[] = [];
    public-read var columnCount : Integer =
        bind (sizeof tableColumns) on replace {
        group.content = tableColumns;
    }
    
    def vScrollBar = ScrollBar {
        vertical: true
        min: 0
        max: 0
        value: 0
        blocksMouse: true
        visible: false
    }

    postinit {

        var w = (width + (2 * columnCount))/columnCount;

        var index = 0;

        for(i in [0..tableModel.getColumnCount()-1]) {
            insert TableColumn {
                index: index
                tableView: this
                items: bind items
                name: tableModel.getColumnName(i)
                width: w
            } into tableColumns;
            index++;
        }

        addScrollBarListeners();
    }

    function addScrollBarListeners() : Void {
        for(tc in tableColumns) {
            tc.onVScrollMinChange = onVScrollMinChange;
            tc.onVScrollMaxChange = onVScrollMaxChange;
            tc.onVScrollValueChange = onVScrollValueChange;
            tc.onVScrollVisibleAmountChange = onVScrollVisibleAmountChange;
            tc.onVScrollVisibleChange = onVScrollVisibleChange;
        }
    }
    
    function onVScrollMinChange(value : Float) : Void {
        vScrollBar.min = value;
    }

    function onVScrollMaxChange(value : Float) : Void {
        vScrollBar.max = value;
    }

    function onVScrollValueChange(value : Float) : Void {
        vScrollBar.value = value;
    }

    function onVScrollVisibleAmountChange(value : Float) : Void {
        vScrollBar.visibleAmount = value;
    }

    function onVScrollVisibleChange(visible : Boolean) : Void {
        vScrollBar.visible = visible;
    }

    def vScrollBarValue = bind vScrollBar.value on replace {
        FX.deferAction(updateScrollBars);
    }

    def background = Rectangle {
        fill: Color.LIGHTGRAY
    }

    def mouseCaptureRect = Rectangle {
        fill: Color.TRANSPARENT
        stroke: Color.GRAY
        onMouseReleased: function(me) {
            requestFocus();
        }
    }

    init {
        children = [ background, group, vScrollBar, mouseCaptureRect ];
        focusTraversable = true;
    }

    override function doLayout() : Void {

        background.width = width;
        background.height = height;
        
        mouseCaptureRect.width = width;
        mouseCaptureRect.height = height;

        var x = 0.0;
        var scrollW = getNodePrefWidth(vScrollBar) + 1;
        var defaultW = ((width - scrollW) + (2 * columnCount))/columnCount;
        var w = defaultW;

        var colIndex = 1;
        for(tc in tableColumns) {
            
            if(tc.columnWidth > 2) {
                w = tc.columnWidth;
                defaultW = (width - x - scrollW - w +
                    (2 * (columnCount - colIndex)))/(columnCount - colIndex);
            } else {
                w = defaultW;
            }
            
            layoutNode(tc, x, 0, w, height);
            x = x + w - 2;
            colIndex++;
        }
        
        layoutNode(vScrollBar, width - scrollW, TableColumn.TABLE_HEADER_HEIGHT,
            scrollW, height - TableColumn.TABLE_HEADER_HEIGHT);
    }

    function updateScrollBars() : Void {
        for(tc in tableColumns) {
            tc.updateVScrollValue(vScrollBarValue);
        }
    }

    /**
     * @treatasprivate
     */
    public function onSelect(index : Integer) : Void {
        for(tc in tableColumns) {
            tc.onSelect(index);
        }
        selectedRow = index;
    }

    override var onKeyPressed = function(ke : KeyEvent) : Void {

        if(columnCount <= 0) { return; }

        if(ke.code == KeyCode.VK_UP) {
            selectPreviousRow();
        } else if(ke.code == KeyCode.VK_DOWN) {
            selectNextRow();
        } else if(ke.code == KeyCode.VK_HOME) {
            selectFirstRow();
        } else if(ke.code == KeyCode.VK_END) {
            selectLastRow();
        } else if(ke.code == KeyCode.VK_PAGE_UP) {
            scrollPageUp();
        } else if(ke.code == KeyCode.VK_PAGE_DOWN) {
            scrollPageDown();
        } else if(ke.code == KeyCode.VK_BACK_SLASH) {
            if (FX.getProperty("javafx.os.name").startsWith("Mac")) {
                if(not ke.metaDown) { return; }
            }
            clearSelection();
        }
    }

    /**
     * @treatasprivate
     */
    public function reorderColumn(
        tableColumn : TableColumn, newIndex : Integer):Void {

        if(newIndex >= columnCount) { return; }

        var oldIndex = Sequences.indexOf(tableColumns, tableColumn);
        delete tableColumn from tableColumns;

        if(newIndex >= 0) {
            insert tableColumn before tableColumns[newIndex];
        } else if(oldIndex > newIndex) {
            insert tableColumn before tableColumns[newIndex - 1];
        }
    }
    
    public function selectPreviousRow():Void {
        tableColumns[0].selectPreviousRow();
    }

    public function selectNextRow():Void {
        tableColumns[0].selectNextRow();
    }

    public function selectFirstRow():Void {
        tableColumns[0].selectFirstRow();
    }

    public function selectLastRow():Void {
        tableColumns[0].selectLastRow();
    }

    public function scrollPageUp():Void {
        tableColumns[0].scrollPageUp();
    }

    public function scrollPageDown():Void {
        tableColumns[0].scrollPageDown();
    }

    public function clearSelection():Void {
        tableColumns[0].clearSelection();
    }

    public override function tableDataChanged() {
        rowCount = tableModel.getRowCount();
    }

    public override function tableRowsDeleted(
        firstRow:Integer, lastRow:Integer) {
        rowCount = tableModel.getRowCount();
    }

    public override function tableRowsInserted(
        firstRow:Integer, lastRow:Integer) {
        rowCount = tableModel.getRowCount();
    }

    public override function tableRowsUpdated(
        firstRow:Integer, lastRow:Integer) {
        for(i in [firstRow..lastRow]) {
            items[i] = "{tableModel.getValueAt(i, 0)}"
        }
    }
}
