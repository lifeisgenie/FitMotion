package FitMotion.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// Spring MVC 설정을 위한 구성 클래스
@Configuration
public class CorsMvcConfig implements WebMvcConfigurer {

    // CORS 매핑을 추가
    @Override
    public void addCorsMappings(CorsRegistry corsRegistry) {

        // 모든 경로에 대해 CORS 설정을 추가.
        corsRegistry.addMapping("/**")
                .allowedOrigins("http://localhost:3000") // 허용된 출처를 설정. 로컬 호스트 3000 포트를 허용.
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("*"); // 허용할 헤더 설정
    }
}
