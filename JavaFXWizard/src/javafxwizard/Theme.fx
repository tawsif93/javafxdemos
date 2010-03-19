/*
 * Theme.fx
 *
 * Created on Mar 19, 2010, 4:28:45 PM
 */

package javafxwizard;

import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;

/**
 * @author Rakesh Menon
 */

public def outerBorderFill = LinearGradient {
    startX: 0.0 startY: 0.0 endX: 0.0 endY: 1.0
    stops: [
        Stop { offset: 0.0 color: Color.web("#B4B4B4") },
        Stop { offset: 0.5 color: Color.web("#9C9C9C") }
    ]
};

public def innerBorderFill = LinearGradient {
    startX: 0.0 startY: 0.0 endX: 0.0 endY: 1.0
    stops: [
        Stop { offset: 0.0 color: Color.web("#F4F4F4") },
        Stop { offset: 0.5 color: Color.web("#BCBCBC") }
    ]
};

public def bodyFill = LinearGradient {
    startX: 0.0 startY: 0.0 endX: 0.0 endY: 1.0
    stops: [
        Stop { offset: 0.0 color: Color.web("#DCDCDC") },
        Stop { offset: 0.5 color: Color.web("#B4B4B4") }
    ]
};

public def titleFont = Font.font("sansserif", FontWeight.BOLD, 12);
