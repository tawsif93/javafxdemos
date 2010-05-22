/*
 * Main.fx
 *
 * Created on Mar 15, 2010, 3:27:47 PM
 */

package javafxtable;

import javafx.scene.layout.LayoutInfo;
import javafx.scene.control.Button;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.VBox;
import javafxtable.control.DefaultTableModel;
import javafxtable.control.TableView;
import javafx.geometry.HPos;
import javafx.scene.layout.HBox;

/**
 * @author Rakesh Menon
 */

var row = 0;

def tableModel = new DefaultTableModel([
    "Col-01", "Col-02", "Col-03", "Col-04", "Col-05"
]);

def table : TableView = TableView {
    layoutInfo: LayoutInfo {
        width: bind table.scene.width
        height: bind (table.scene.height - 40)
    }
    tableModel: tableModel
}

def random = new java.util.Random();

def addButton = Button {

    text: "Add Data"
    
    action: function() {
        for(i in [0..25]) {
            tableModel.addRow([
                "ROW [{row}]",
                "{random.nextInt(999999)/100.0}",
                "{random.nextInt(999999)}",
                "{random.nextInt(999999)/100.0}",
                "{random.nextInt(999999)/100.0}"
            ]);
            row++;
        }
        tableModel.fireTableDataChanged();
    }
}
def clearButton = Button {
    text: "Clear Data"
    action: function() {
        tableModel.clear();
    }
}

Stage {
    scene: Scene {
        width: 400
        height: 400
        content: VBox {
            spacing: 10
            content: [
                table,
                HBox {
                    spacing: 20
                    hpos: HPos.CENTER
                    content: [ addButton, clearButton ]
                }
            ]
        }
    }
}
