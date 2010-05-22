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

public class DefaultTableModel extends AbstractTableModel {

    private List<List> data = new LinkedList<List>();
    private String[] columnNames;

    public DefaultTableModel(String[] columnNames) {
        this.columnNames = columnNames;
    }

    public int getColumnCount() {
        if(columnNames == null) { return 0; }
        return columnNames.length;
    }

    public String getColumnName(int columnIndex) {
        if(columnNames == null) { return ""; }
        return columnNames[columnIndex];
    }

    public int getRowCount() {
        return data.size();
    }

    public Object getValueAt(int rowIndex, int columnIndex) {
        return data.get(rowIndex).get(columnIndex);
    }

    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return false;
    }

    public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
        data.get(rowIndex).set(columnIndex, aValue);
        fireTableRowsUpdated(rowIndex, rowIndex);
    }
    
    public void addRow(Object[] rowData) {

        List list = new LinkedList();
        for(int i=0; i<rowData.length; i++) {
            list.add(rowData[i]);
        }
        data.add(list);

        int rowIndex = getRowCount();
        fireTableRowsInserted(rowIndex, rowIndex);
    }

    public void removeRow(int rowIndex) {
        data.remove(rowIndex);
        fireTableRowsDeleted(rowIndex, rowIndex);
    }

    public void clear() {
        data.clear();
        fireTableDataChanged();
    }
}
