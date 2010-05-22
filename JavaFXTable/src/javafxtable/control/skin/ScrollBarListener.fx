/*
 * ScrollBarListener.fx
 *
 * Created on Mar 24, 2010, 2:02:57 PM
 */

package javafxtable.control.skin;

import javafx.scene.control.ScrollBar;

/**
 * @author Rakesh Menon
 */

public mixin class ScrollBarListener {

    protected var hScroll: ScrollBar;
    protected var onHScrollVisibleChange : function(value : Boolean);
    protected var onHScrollMinChange : function (value : Float);
    protected var onHScrollMaxChange : function (value : Float);
    protected var onHScrollValueChange : function (value : Float);
    protected var onHScrollVisibleAmountChange : function (value : Float);

    protected var vScroll: ScrollBar;
    protected var onVScrollVisibleChange : function(value : Boolean);
    protected var onVScrollMinChange : function (value : Float);
    protected var onVScrollMaxChange : function (value : Float);
    protected var onVScrollValueChange : function (value : Float);
    protected var onVScrollVisibleAmountChange : function (value : Float);

    def onHScrollMinChangeValue = bind hScroll.min on replace {
        onHScrollMinChange(onHScrollMinChangeValue)
    }

    def onHScrollMaxChangeValue = bind hScroll.max on replace {
        onHScrollMaxChange(onHScrollMaxChangeValue);
    }

    def updateHScrollbarValue = bind hScroll.value on replace {
        onHScrollValueChange(updateHScrollbarValue);
    }

    def updateHScrollbarVisibleAmount = bind hScroll.visibleAmount on replace {
        onHScrollVisibleAmountChange(updateHScrollbarVisibleAmount);
    }

    def onVScrollMinChangeValue = bind vScroll.min on replace {
        onVScrollMinChange(onVScrollMinChangeValue)
    }

    def onVScrollMaxChangeValue = bind vScroll.max on replace {
        onVScrollMaxChange(onVScrollMaxChangeValue);
    }

    def updateVScrollbarValue = bind vScroll.value on replace {
        onVScrollValueChange(updateVScrollbarValue);
    }

    def updateVScrollbarVisibleAmount = bind vScroll.visibleAmount on replace {
        onVScrollVisibleAmountChange(updateVScrollbarVisibleAmount);
    }

    def updateVScrollbarVisible = bind vScroll.visible on replace {
        onVScrollVisibleChange(updateVScrollbarVisible);
    }

    public function updateVScrollValue(value : Float) : Void {
        vScroll.value = value;
    }
}
