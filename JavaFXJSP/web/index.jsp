<%-- 
    Document   : index
    Created on : Mar 29, 2010, 11:11:16 AM
    Author     : Rakesh Menon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="/WEB-INF/tlds/javafx" prefix="javafx" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JavaFX + JSP Page</title>
    </head>
    <body>
        <javafx:Applet
            version="1.2"
            codebase="http://javafx.com/samples/Calculator/webstart/"
            archive="Calculator.jar"
            code="calculator.Main"
            width="221"
            height="249"
            name="Calculator"
            draggable="true"
            loading_image_url="http://javafx.com/samples/Calculator/desc-resources/splash.gif"
            loading_image_width="240"
            loading_image_height="320"
            args="key=value"
        />
    </body>
</html>
