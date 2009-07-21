/*
 * Utilities.fx
 *
 * Created on 21 Jul, 2009, 8:49:02 AM
 */

package saveasimage;

import javafx.scene.Node;
import java.awt.Frame;
import javax.swing.JFrame;
import java.awt.Container;
import javafx.geometry.Bounds;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;
import java.applet.Applet;

/**
 * @author Rakesh Menon
 */

public function getContainer() : Container {

    var container : Container;

    if("{__PROFILE__}" == "browser") { // Applet
        container = FX.getArgument("javafx.applet") as Applet;
    } else { // Standalone
        var frames = Frame.getFrames();
        // We may improve this logic so as to find the
        // exact Stage (Frame) based on its title
        container = (frames[0] as JFrame).getContentPane();
    }

    return container;
}

public function saveAsImage(node : Node, file : File) : Void {    
    save(getContainer(), node.localToScene(node.boundsInLocal), file);
}

function save(container : Container, bounds : Bounds, file : File) {

    var bufferedImage = new BufferedImage(
        bounds.width, bounds.height, BufferedImage.TYPE_INT_ARGB);
    var graphics = bufferedImage.getGraphics();
    graphics.translate(-bounds.minX, -bounds.minY);
    container.paint(graphics);
    graphics.dispose();

    ImageIO.write(bufferedImage, "png", file);
}
