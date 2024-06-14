package FitMotion.backend.filter;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.dto.request.RequestLoginDTO;
import FitMotion.backend.jwt.JWTUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletInputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.util.StreamUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

// formLogin 방식을 disable 했기 때문에 로그인을 진행하기 위해서 필터를 커스텀하여 등록
// 로그인 검증을 위한 커스텀 UsernamePasswordAuthentication 필터
// HTTP 요청으로부터 인증 정보를 추출하고 이를 기반으로 인증 시도
// 로그인 요청을 처리하고 JWT를 발급
public class LoginFilter extends UsernamePasswordAuthenticationFilter {

    // 회원 검증의 경우 UsernamePasswordAuthenticationFilter가 호출한 AuthenticationManager를 통해 진행하며
    // DB에서 조회한 데이터를 UserDetailsService를 통해 받음
    private final AuthenticationManager authenticationManager;

    // JWTUtil 주입
    // 로그인이 성공됐을 때 실행되는 메소드에서 JWT를 발급받아 응답
    private final JWTUtil jwtUtil;

    private final Long accessTokenExpiration;

    public LoginFilter(AuthenticationManager authenticationManager, JWTUtil jwtUtil, Long accessTokenExpiration) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        this.accessTokenExpiration = accessTokenExpiration;
    }

    // HTTP 요청으로부터 인증 정보를 추출하고, 이를 기반으로 인증 시도.
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            ServletInputStream inputStream = request.getInputStream();
            String messageBody = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);
            RequestLoginDTO dto = objectMapper.readValue(messageBody, RequestLoginDTO.class);

            // 클라이언트 요청에서 email, password 추출
            String email = dto.getEmail();
            String password = dto.getPassword();

            // 스프링 시큐리티에서 email과 password를 검증하기 위해서는 token에 담아야 함
            UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(email, password);

            Authentication auth = authenticationManager.authenticate(authToken);

            // token에 담은 검증을 위한 AuthenticationManager로 전달
            return authenticationManager.authenticate(authToken);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    // 로그인 성공시 실행하는 메소드 (여기서 JWT를 발급하면 됨)
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) throws IOException {

        CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();

        String email = customUserDetails.getUsername();
        String accessToken = jwtUtil.createJwt(email, accessTokenExpiration);

        // header는 ("키 값", "접두사+띄어쓰기" + token) 이렇게 응답
        response.addHeader("Authorization", "Bearer " + accessToken);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"accessToken\": \"" + accessToken + "\"}");
    }

    // 로그인 실패시 실행하는 메소드
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"error\": \"Authentication failed\"}");
    }
}