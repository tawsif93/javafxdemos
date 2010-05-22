/*
 * TableColumnViewSkin.fx
 *
 * Created on Mar 18, 2010, 12:01:45 PM
 */

package javafxtable.control.skin;

import com.sun.javafx.scene.control.skin.ListViewSkin;
import com.sun.javafx.scene.control.skin.VirtualScrollBar;
import javafx.scene.control.ListView;

/**
 * @author Rakesh Menon
 */

public class TableColumnViewSkin extends ListViewSkin, ScrollBarListener {

    postinit {

        for(node in flow.content) {
            if(node instanceof VirtualScrollBar) {
                if((node as VirtualScrollBar).vertical) {
                    vScroll = (node as VirtualScrollBar);
                } else {
                    hScroll = (node as VirtualScrollBar);
                }
            }
        }
        
        delete vScroll from flow.content;
        delete hScroll from flow.content;
    }

    /**
     * @treatasprivate
     */
    public function onSelectPreviousRow():Void {
        flow.show((control as ListView).selectedIndex);
    }

    /**
     * @treatasprivate
     */
    public function onSelectNextRow():Void {
        flow.show((control as ListView).selectedIndex);
    }

    /**
     * @treatasprivate
     */
    public function onSelectFirstRow():Void {
        flow.setPosition(0);
    }

    /**
     * @treatasprivate
     */
    public function onSelectLastRow():Void {
        flow.setPosition(1);
    }
}
