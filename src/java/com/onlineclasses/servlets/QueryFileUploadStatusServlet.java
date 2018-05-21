package com.onlineclasses.servlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.onlineclasses.db.DB;
import com.onlineclasses.entities.AttachedFile;
import com.onlineclasses.entities.BasicResponse;
import com.onlineclasses.entities.GoogleUser;
import com.onlineclasses.entities.LoginRequest;
import com.onlineclasses.entities.OClass;
import com.onlineclasses.entities.QueryFileUploadRequest;
import com.onlineclasses.entities.QueryFileUploadResponse;
import com.onlineclasses.entities.User;
import com.onlineclasses.utils.Utils;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/servlets/query_file_upload_status"})
public class QueryFileUploadStatusServlet extends ServletBase {

    @Override
    protected BasicResponse handleRequest(String requestString, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        QueryFileUploadRequest queryFileUploadRequest = Utils.gson().fromJson(requestString, QueryFileUploadRequest.class);

        OClass oClass = DB.get(queryFileUploadRequest.oclass_id, OClass.class);
        if (oClass == null) {
            return new BasicResponse(-1, "class not found");
        }
        
        AttachedFile attachedFile = DB.getClassAttachedFile(oClass, queryFileUploadRequest.file_name);
        if (attachedFile == null) {
            return new BasicResponse(-1, "attached file not found");
        }
               
        QueryFileUploadResponse queryFileUploadResponse = new QueryFileUploadResponse();
        queryFileUploadResponse.file_size = attachedFile.size;
        queryFileUploadResponse.uploaded = attachedFile.uploaded;
        return queryFileUploadResponse;
    }

}
