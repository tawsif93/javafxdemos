/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxtable.control;

import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author Rakesh Menon
 */

public abstract class AbstractTableModel implements TableModel {

    protected List<TableModelListener> listenerList =
            new LinkedList<TableModelListener>();

    @Override
    public void addTableModelListener(TableModelListener listener) {
        listenerList.add(listener);
    }

    @Override
    public void removeTableModelListener(TableModelListener listener) {
        listenerList.remove(listener);
    }

    public void fireTableDataChanged() {
        for(TableModelListener listener : listenerList) {
            listener.tableDataChanged();
        }
    }

    public void fireTableRowsDeleted(int firstRow, int lastRow) {
        for(TableModelListener listener : listenerList) {
            listener.tableRowsDeleted(firstRow, lastRow);
        }
    }

    public void fireTableRowsInserted(int firstRow, int lastRow) {
        for(TableModelListener listener : listenerList) {
            listener.tableRowsInserted(firstRow, lastRow);
        }
    }

    public void fireTableRowsUpdated(int firstRow, int lastRow) {
        for(TableModelListener listener : listenerList) {
            listener.tableRowsUpdated(firstRow, lastRow);
        }
    }
}
