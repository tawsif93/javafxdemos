/*
 * Main.fx
 *
 * Created on Oct 27, 2009, 11:11:01 AM
 */

package javafxjtable;

import javafx.stage.Stage;
import javafx.scene.Scene;

/**
 * @author Rakesh Menon
 */

var fxTable = FXTable {
    columnNames: [
        "First Name",
        "Last Name",
        "Sport",
        "# of Years",
        "Vegetarian"
    ]
    width: 400
    height: 200
};
 
fxTable.addRow(["Mary", "Campione", "Snowboarding", 5, Boolean.FALSE]);
fxTable.addRow(["Alison", "Huml", "Rowing", 3, Boolean.TRUE]);
fxTable.addRow(["Kathy", "Walrath", "Knitting", 2, Boolean.FALSE]);
fxTable.addRow(["Sharon", "Zakhour", "Speed reading", 20, Boolean.TRUE]);
fxTable.addRow(["Philip", "Milne", "Pool", 10, Boolean.FALSE]);

Stage {
    title: "JavaFX - JTable"
    scene: Scene {
        width: 400
        height: 200
        content: [ fxTable ]
    }
}
