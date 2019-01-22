package com.onlineclasses.servlets;

import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

public class CacheControlFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        if (Config.getBool("website.cache_enabled")) {
            return;
        }
        HttpServletResponse resp = (HttpServletResponse) response;
        resp.setHeader("Expires", "Tue, 03 Jul 2001 06:00:00 GMT");
        resp.setDateHeader("Last-Modified", new Date().getTime());
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0, post-check=0, pre-check=0");
        resp.setHeader("Pragma", "no-cache");

        chain.doFilter(request, response);               
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {        
        if (Config.getBool("website.cache_enabled")) {
            Utils.info("Browser cache is enabled");
        }
    }

    @Override
    public void destroy() {        
    }

}