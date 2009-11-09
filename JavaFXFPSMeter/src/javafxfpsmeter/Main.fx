/**
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Main.fx
 *
 * Created on 7 Nov, 2009, 10:01:13 AM
 */

package javafxfpsmeter;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;


/**
 * @author Rakesh Menon
 */

def canvas = Canvas { };

var fpsText : Text = Text {
    font: Font { size: 20 }
    content: bind "FPS: {canvas.displayFPS}"
    layoutX: 10
    layoutY: 10
    textOrigin: TextOrigin.TOP
}

var countText : Text = Text {
    font: Font { size: 20 }
    content: bind "Count: {canvas.count}"
    layoutX: bind (580 - countText.layoutBounds.width)
    layoutY: 10
    textOrigin: TextOrigin.TOP
}

var stage = Stage {
    title: "JavaFX Meter"
    scene: Scene {
        content: [ canvas, fpsText, countText ]
    }
}

canvas.start();
