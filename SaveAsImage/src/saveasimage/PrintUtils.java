/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package saveasimage;

import java.awt.image.RenderedImage;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.print.Doc;
import javax.print.DocFlavor;
import javax.print.DocPrintJob;
import javax.print.PrintException;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.SimpleDoc;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.standard.Copies;

/**
 *
 * @author Rakesh Menon
 */
public class PrintUtils {

    public static void print(RenderedImage image)
            throws PrinterException, PrintException, IOException {

        System.out.println("PRINTING...");

        DocFlavor docFlavor = DocFlavor.INPUT_STREAM.PNG;

        PrintRequestAttributeSet attributes = new HashPrintRequestAttributeSet();
        attributes.add(new Copies(1));

        PrintService printServices[] = PrintServiceLookup.lookupPrintServices(
                docFlavor, attributes);
        if (printServices.length == 0) {
            System.err.println("PrintService for PNG not available!");
            throw new RuntimeException("PrintService for PNG not available!");
        }

        System.out.println("Got PrintService: " + printServices[0].getName());

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ImageIO.write(image, "png", out);
        ByteArrayInputStream in = new ByteArrayInputStream(out.toByteArray());

        // Show PrintDialog
        boolean print = PrinterJob.getPrinterJob().printDialog(attributes);

        if(print) {
            DocPrintJob job = printServices[0].createPrintJob();
            Doc doc = new SimpleDoc(in, docFlavor, null);
            job.print(doc, attributes);
            in.close();
        }

        System.out.println("Done PrintService: " + print);
    }
}
