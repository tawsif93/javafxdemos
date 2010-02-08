package deployment;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Container;
import java.awt.EventQueue;
import java.awt.event.ComponentAdapter;
import java.net.URL;
import javax.swing.JFrame;
import java.lang.reflect.Method;
import javax.jnlp.DownloadServiceListener;

/**
 *
 * @author Rakesh Menon
 */

public class ProgressListener extends ComponentAdapter 
    implements DownloadServiceListener {
    
    private static boolean visible , disposed;
    private static Container container = null;
    private static JFrame jFrame = null;
    private static ProgressView view = null;
    
    public ProgressListener() {
        create();
    }
    
    public ProgressListener(Object Surface) {
        try {
            container = (Container) Surface;
        } catch (Throwable t) { }
        create();
    }
    
    private void create() {
        
        view = new ProgressView();
        
        if (container != null) { // Applet Mode
            container.add(view, BorderLayout.CENTER);
        } else { // Java Web Start Mode
            jFrame = new JFrame();
            jFrame.setUndecorated(true);
            jFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            jFrame.getContentPane().add(view, BorderLayout.CENTER);
            jFrame.pack();
            jFrame.setLocationRelativeTo(null);
            visible = false;
        }
        
        updateProgress(0);
    }
    
    private String getFileName(URL url) {

        if(url == null) { return ""; }

        try {
            String file = url.getFile().toString();
            int index = file.lastIndexOf("/");
            if (index >= 0) {
                file = file.substring(index + 1);
            }
            return file;
        } catch (Exception e) { }

        return "" + url;
    }
    
    private void updateProgress(int overallPercent) {

        try {
            
            if (disposed) { return; }

            if (overallPercent == 0 || overallPercent >= 99) {
                view.setTitle("Launching");
                view.setMessage("Application");
                view.setProgress(-1);
            }
            
            if (visible) {
                
                if (overallPercent >= 99 && jFrame != null) {
                    visible = false;
                    disposed = true;
                    final JFrame f = jFrame;
                    EventQueue.invokeLater(new Runnable() {
                        @Override
                        public void run() {
                            f.setVisible(false);
                            f.dispose();
                        }
                    });
                }

            } else {

                if (overallPercent > 0 && overallPercent < 100 && jFrame != null) {
                    final JFrame f = jFrame;
                    visible = true;
                    EventQueue.invokeLater(new Runnable() {
                        @Override
                        public void run() {
                            f.setVisible(true);
                        }
                    });
                }
            }

        } catch (Throwable t) { t.printStackTrace(); }
    }
    
    @Override
    public void progress(
        URL url, String version, long readSoFar,
        long total, int overallPercent) {

        if (!disposed) {
            view.setTitle("Downloading...");
            view.setMessage(getFileName(url));
            view.setSubProgress( (int) ((100 * readSoFar) / total));
            view.setProgress(overallPercent);
        }
        
        updateProgress(overallPercent);
    }

    @Override
    public void validating(
        URL url, String version, long entry,
        long total, int overallPercent) {
        
        if (!disposed) {
            view.setTitle("Validating...");
            view.setMessage(getFileName(url));
            view.setSubProgress( (int) ((100 * entry) / total));
            view.setProgress(overallPercent);
        }
        
        updateProgress(overallPercent);
    }

    @Override
    public void upgradingArchive(
        URL url, String version,
        int patchPercent, int overallPercent) {

        if (!disposed) {
            view.setTitle("Patching...");
            view.setMessage(getFileName(url));
            view.setSubProgress(patchPercent);
            view.setProgress(overallPercent);
        }
        
        updateProgress(overallPercent);
    }

    @Override
    public void downloadFailed(URL url, String version) {
        if (!disposed) {
            view.setTitle("Download Failed");
            view.setMessage(getFileName(url));
            updateProgress(100);
        }
    }    
}
