/*
 * FXTable.fx
 *
 * Created on Oct 27, 2009, 11:13:57 AM
 */

package javafxjtable;

import javafx.ext.swing.SwingComponent;
import javax.swing.JComponent;
import javax.swing.JTable;
import javax.swing.JScrollPane;
import javax.swing.table.DefaultTableModel;

/**
 * @author Rakesh Menon
 */

public class FXTable extends SwingComponent {

    var jTable : JTable;
    var tableModel : DefaultTableModel;

    public-init var columnNames : String[] on replace {
        if(sizeof columnNames > 0) {
            tableModel = new DefaultTableModel(columnNames, 0);
            jTable.setModel(tableModel);
        }
    }

    override function createJComponent() : JComponent {
        jTable = new JTable();
        return new JScrollPane(jTable);
    }
    
    public function addRow(data : Object[]) : Void {
        tableModel.addRow(data);
    }
}
