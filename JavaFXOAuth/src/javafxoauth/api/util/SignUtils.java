/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javafxoauth.api.util;

import com.sun.javafx.io.http.impl.Base64;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

/**
 * @author Rakesh Menon
 */

public class SignUtils {

    private static final String HMACSHA1 = "HmacSHA1";

    public static final String createSignature(
        String data, String key) {

        String result = null;

        try {

            /**
             * Constructs a secret key from the given byte array.
             *
             * javax.crypto.spec.SecretKeySpec
             *
             * SecretKeySpec secretKeySpec = new SecretKeySpec(
             *       key.getBytes(), HMACSHA1);
             *
             **/
            Class secretKeySpecClass = Class.forName(
                    "javax.crypto.spec.SecretKeySpec");
            Constructor secretKeySpecConstructor =
                secretKeySpecClass.getConstructor(
                    key.getBytes().getClass(), String.class);
            Object secretKeySpec = secretKeySpecConstructor.newInstance(
                    key.getBytes(), HMACSHA1);

            /**
             * Generates an Mac object that implements
             * HmacSHA1 algorithm.
             *
             * javax.crypto.Mac.getInstance(HMACSHA1);
             *
             * Mac mac = Mac.getInstance(HMACSHA1);
             *
             **/
            Class macClass = Class.forName("javax.crypto.Mac");
            Method getInstanceMethod = macClass.getDeclaredMethod(
                "getInstance", String.class);
            Object mac = getInstanceMethod.invoke(null, HMACSHA1);

            /**
             * Initializes this Mac object with the given key.
             *
             * mac.init(secretKeySpec);
             *
             **/
            Class keyClass = Class.forName("java.security.Key");
            Method initMethod = macClass.getDeclaredMethod(
                "init", keyClass);
            initMethod.invoke(mac, secretKeySpec);

            /**
             * Finishes the MAC operation and returns result.
             *
             * byte[] finalMac = mac.doFinal(data.getBytes());
             *
             **/
            Method doFinalMethod = macClass.getDeclaredMethod(
                "doFinal", data.getBytes().getClass());
            Object finalMac = doFinalMethod.invoke(
                    mac, data.getBytes());

            /**
             * Base64 encode the hmac
             */
            result = Base64.encode((byte[]) finalMac);

        } catch (Exception e) {

            e.printStackTrace();
            
            throw new java.lang.RuntimeException(
                "Failed to generate HMAC: " + e.getMessage());
        }

        return result;
    }
}
