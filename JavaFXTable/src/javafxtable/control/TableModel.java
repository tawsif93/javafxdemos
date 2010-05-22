/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxtable.control;

/**
 *
 * @author Rakesh Menon
 */
public interface TableModel {

    public void addTableModelListener(TableModelListener l);

    public void removeTableModelListener(TableModelListener l);

    public int getColumnCount();

    public String getColumnName(int columnIndex);

    public int getRowCount();

    public Object getValueAt(int rowIndex, int columnIndex);

    public void setValueAt(Object aValue, int rowIndex, int columnIndex);

    public void addRow(Object[] rowData);

    public void removeRow(int rowIndex);

    public void clear();
}
