package javafxoauth.api.util;

import java.io.InputStream;
import java.io.InputStreamReader;

/**
 *
 * @author Rakesh Menon
 */
public class IOUtils {

    public static String getStreamAsString(InputStream in) {

        StringBuffer buffer = new StringBuffer();

        try {

            InputStreamReader inr = new InputStreamReader(in);
            char[] charArray = new char[1024];
            int read = 0;
            while((read = inr.read(charArray, 0, 1024)) > 0) {
                buffer.append(new String(charArray, 0, read));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return buffer.toString();
    }
}
