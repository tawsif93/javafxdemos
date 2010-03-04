/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package downloadservice;

import java.applet.Applet;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Label;
import javax.jnlp.DownloadService2;
import javax.jnlp.DownloadService2.ResourceSpec;
import javax.jnlp.ServiceManager;

/**
 *
 * @author Rakesh Menon
 */
public class DownloadServiceApplet extends Applet {

    private static final String JNLP_START = "http://dl.javafx.com/";
    private static final String JNLP_END = "/javafx-rt.jnlp";

    public static String getJavaFXVersion() throws Exception {

        String javaFXVersion = "-";

        DownloadService2 service = (DownloadService2)
            ServiceManager.lookup("javax.jnlp.DownloadService2");

        ResourceSpec spec = new ResourceSpec(
                "http://dl.javafx.com/.*", null, DownloadService2.EXTENSION);
        ResourceSpec[] resource = service.getCachedResources(spec);

        for(ResourceSpec rs : resource) {
            String url = rs.getUrl();
            if(url.startsWith(JNLP_START) && url.endsWith(JNLP_END)) {
                javaFXVersion = url.substring(JNLP_START.length(), url.indexOf(JNLP_END));
                break;
            }
        }

        return javaFXVersion;
    }

    private Label awtLabel = null;
    
    public DownloadServiceApplet() {

        setLayout(new BorderLayout());

        awtLabel = new Label();
        awtLabel.setBackground(new Color(240, 240, 240));
        add(awtLabel);
    }
    
    public void init() {        
        try {
            String javaFXVersion = getJavaFXVersion();
            awtLabel.setText(javaFXVersion);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
