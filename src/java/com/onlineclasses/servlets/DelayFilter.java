package com.onlineclasses.servlets;

import com.onlineclasses.utils.Config;
import com.onlineclasses.utils.Utils;
import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

public class DelayFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        
        if ( delay == 0) {
            return;
        }
        Utils.sleep(delay);  
        chain.doFilter(request, response);      
    }

    private int delay;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {        
        delay = Config.getInt("website.simulate_delay_ms");
    }

    @Override
    public void destroy() {        
    }

}