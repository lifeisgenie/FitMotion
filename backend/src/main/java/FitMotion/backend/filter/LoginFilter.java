package FitMotion.backend.filter;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.jwt.JWTUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class LoginFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;
    private final JWTUtil jwtUtil;

    public LoginFilter(AuthenticationManager authenticationManager, JWTUtil jwtUtil) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        setFilterProcessesUrl("/login"); // 로그인 URL 설정
    }

    // HTTP 요청으로부터 인증 정보를 추출하고, 이를 기반으로 인증 시도.
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        // 인증 토큰 생성
        // HTTP 요청으로부터 이메일, 비밀번호 추출.
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println(email);

        // 인증 토큰 생성.
        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(email, password);

        // 인증 시도.
        return authenticationManager.authenticate(authToken);
    }

//    public String obtainEmail(HttpServletRequest request) {
//        return request.getParameter("email");
//    }

//    @Override
//    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) throws IOException {
//
//        // 인증 성공 시 JWT 생성
//        CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();
//
//        String email = customUserDetails.getUsername();
//        String jwt = jwtUtil.createToken(email, 60*60*10L);
//
//        // 응답 데이터를 JSON 형태로 작성
//        Map<String, Object> responseData = new HashMap<>();
//        responseData.put("statusCode", 200);
//        responseData.put("message", "로그인 성공");
//        Map<String, String> data = new HashMap<>();
//        data.put("email", CustomUserDetails.getUsername());
//        responseData.put("data", data);
//
//        // 응답 설정
//        response.setContentType("application/json");
//        response.setStatus(HttpServletResponse.SC_OK);
//        new ObjectMapper().writeValue(response.getOutputStream(), responseData);
//    }

//    protected void unsuccessfulPasswordNotCorrectAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException {
//        String email = obtainEmail(request);
//        String password = obtainPassword(request);
//
//        // 응답 데이터를 JSON 형태로 작성
//        Map<String, Object> responseData = new HashMap<>();
//        responseData.put("statusCode", 401);
//        responseData.put("message", "잘못된 비밀번호 입니다.");
//        Map<String, String> data = new HashMap<>();
//        data.put("email", CustomUserDetails.getUsername());
//        responseData.put("data", data);
//
//        // 응답 설정
//        response.setContentType("application/json");
//        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//        new ObjectMapper().writeValue(response.getOutputStream(), responseData);
//    }
//
//    // 이메일이 존재하지 않을 때의 예외 처리 메서드
//    protected void unsuccessfulEmailNotFoundAuthentication(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        String email = obtainEmail(request);
//        String password = obtainPassword(request);
//
//        // 응답 데이터를 JSON 형태로 작성
//        Map<String, Object> responseData = new HashMap<>();
//        responseData.put("statusCode", 404);
//        responseData.put("message", "존재하지 않는 계정입니다.");
//        Map<String, String> data = new HashMap<>();
//        data.put("email", CustomUserDetails.getUsername());
//        responseData.put("data", data);
//
//        // 응답 설정
//        response.setContentType("application/json");
//        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
//        new ObjectMapper().writeValue(response.getOutputStream(), responseData);
//    }
//
//    @Override
//    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException {
//        String email = obtainEmail(request);
//        String password = obtainPassword(request);
//
//        // 응답 데이터를 JSON 형태로 작성
//        Map<String, Object> responseData = new HashMap<>();
//        responseData.put("statusCode", 500);
//        responseData.put("message", "로그인 실패");
//        Map<String, String> data = new HashMap<>();
//        data.put("email", CustomUserDetails.getUsername());
//        responseData.put("data", data);
//
//        // 응답 설정
//        response.setContentType("application/json");
//        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//        new ObjectMapper().writeValue(response.getOutputStream(), responseData);
//    }
}
