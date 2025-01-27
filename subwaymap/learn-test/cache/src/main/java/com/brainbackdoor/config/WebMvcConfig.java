package com.brainbackdoor.config;

import com.brainbackdoor.support.ResourceVersion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.http.CacheControl;
import org.springframework.web.filter.ShallowEtagHeaderFilter;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import javax.servlet.Filter;
import java.time.Duration;

@Configuration
@EnableWebMvc
public class WebMvcConfig implements WebMvcConfigurer {
    public static final String PREFIX_STATIC_RESOURCES = "/resources";


    private final ResourceVersion version;

    @Autowired
    public WebMvcConfig(ResourceVersion version) {
        this.version = version;
    }

    @Override
    public void addInterceptors(final InterceptorRegistry registry) {
        WebContentInterceptor interceptor = new WebContentInterceptor();
        interceptor.addCacheMapping(CacheControl.noCache().cachePrivate(), "/");
        registry.addInterceptor(interceptor);
    }

    @Bean
    public FilterRegistrationBean filterRegistrationBean(){
        FilterRegistrationBean registration = new FilterRegistrationBean();
        Filter etagHeaderFilter = new ShallowEtagHeaderFilter();
        registration.setFilter(etagHeaderFilter);
        registration.addUrlPatterns("/etag", PREFIX_STATIC_RESOURCES + "/" + version.getVersion() + "/*");
        return registration;
    }

    @Override
    public void addResourceHandlers(final ResourceHandlerRegistry registry) {
        registry.addResourceHandler(PREFIX_STATIC_RESOURCES + "/" + version.getVersion() + "/js/**")
                .addResourceLocations("classpath:/js/") // NOTE: 핸들러를 통해 들어온 정적 파일을 어디에 매칭할 것인지
                .setCacheControl(CacheControl.maxAge(Duration.ofDays(365)).cachePublic());

    }
}
