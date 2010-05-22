/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxtable.control;

/**
 *
 * @author Rakesh Menon
 */
public interface TableModelListener {

    public void tableDataChanged();
    
    public void tableRowsDeleted(int firstRow, int lastRow);
    public void tableRowsInserted(int firstRow, int lastRow);
    public void tableRowsUpdated(int firstRow, int lastRow);
}
