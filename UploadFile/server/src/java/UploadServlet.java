/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author javafx
 */
public class UploadServlet extends HttpServlet {

    private static final String DOWNLOAD_DIR = System.getProperty("user.home") + "/JavaFXDownloads";

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/xml;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        String fileName = request.getParameter("file");
        if(fileName == null) { fileName = "download.dat"; }
        
        try {

            File downloadDir = new File(DOWNLOAD_DIR);
            if(!downloadDir.exists()) {
                downloadDir.mkdirs();
            }
            File downloadFile = new File(downloadDir, fileName);
            FileOutputStream out = new FileOutputStream(downloadFile);

            long totalBytes = 0;

            InputStream is = request.getInputStream();
            BufferedInputStream in = new BufferedInputStream(is);
            byte[] bytes = new byte[1024];
            int read = in.read(bytes, 0, 1024);
            while (read > 0) {
                out.write(bytes, 0, read);
                totalBytes += read;
                read = in.read(bytes, 0, 1024);
            }

            out.close();
            is.close();

            System.out.println("Download - " + fileName + " - " + totalBytes);
            
            printWriter.println("<upload>");
            printWriter.println("    <file>" + fileName + "</file>");
            printWriter.println("    <local>" + downloadFile + "</local>");
            printWriter.println("    <status>SUCCESS</file>");
            printWriter.println("</upload>");

        } catch (Exception e) {

            e.printStackTrace();
            
            printWriter.println("<upload>");
            printWriter.println("    <file>" + fileName + "</file>");
            printWriter.println("    <local>-</local>");
            printWriter.println("    <status>FAILURE</file>");
            printWriter.println("</upload>");

        } finally {
            printWriter.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
