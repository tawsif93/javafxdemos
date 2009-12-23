/*
 * HeaderCell.fx
 *
 * Created on Dec 22, 2009, 4:48:58 PM
 */

package javafxdatabase.view;

import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;

/**
 * @author Rakesh Menon
 */

public class HeaderCell extends Cell {
    override var fill = Color.rgb(93, 93, 93);
    override var textFill = Color.LIGHTGRAY;
    override var font = Font.font("sansserif", FontWeight.BOLD, 12);
}
