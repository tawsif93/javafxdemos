/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package modaldialog;

import java.awt.AWTEvent;

/**
 *
 * @author Rakesh Menon
 */

public interface EventFilter {
    public boolean accept(AWTEvent event);
}
