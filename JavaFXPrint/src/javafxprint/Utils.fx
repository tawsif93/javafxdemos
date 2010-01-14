/*
 * Utils.fx
 *
 * Created on Jan 14, 2010, 11:17:30 AM
 */

package javafxprint;

import javafx.geometry.Bounds;
import javafx.scene.Node;
import java.applet.Applet;
import java.awt.Container;
import java.awt.Frame;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;
import javax.swing.JFrame;

/**
 * @author Rakesh Menon
 */

function getContainer() : Container {

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

function toBufferedImage(container : Container, bounds : Bounds) : BufferedImage {

    var bufferedImage = new BufferedImage(
        bounds.width, bounds.height, BufferedImage.TYPE_INT_ARGB);

    var graphics = bufferedImage.getGraphics();
    graphics.translate(-bounds.minX, -bounds.minY);
    container.paint(graphics);
    graphics.dispose();

    return bufferedImage;
}

function save(container : Container, bounds : Bounds, file : File) {
    ImageIO.write(toBufferedImage(container, bounds), "png", file);
}

function print(container : Container, bounds : Bounds) {
    def image = toBufferedImage(container, bounds);
    PrintUtils.print(image);
}

public function saveNode(node : Node, file : File) : Void {
    if(file == null) { return; }
    save(getContainer(), node.localToScene(node.boundsInLocal), file);
}

public function printNode(node : Node) : Void {
    print(getContainer(), node.localToScene(node.boundsInLocal));
}
