package FitMotion.backend.filter;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.service.CustomUserDetailsService;
import FitMotion.backend.jwt.JWTUtil;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JWTFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;
    private final CustomUserDetailsService customUserDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        // Authorization 헤더에서 JWT를 추출
        String authorizationHeader = request.getHeader("Authorization");

        String email = null;
        String jwt = null;

        // Authorization 헤더가 존재하고 Bearer로 시작하는지 확인
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {

            // "Bearer " 이후의 JWT 추출
            jwt = authorizationHeader.split(" ")[1];

            try {
                // JWT에서 이메일 추출
                email = jwtUtil.extractEmail(jwt);
            } catch (ExpiredJwtException e) {
                System.out.println("JWT token is expired");
            }
        }

        // SecurityContext에 인증 정보가 없는 경우 처리
        if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            CustomUserDetails customUserDetails = (CustomUserDetails) this.customUserDetailsService.loadUserByUsername(email);

            // JWT가 유효한지 확인
            if (jwtUtil.validateToken(jwt, customUserDetails.getUsername())) {

                // 유효한 JWT인 경우, UsernamePasswordAuthenticationToken 생성
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                        new UsernamePasswordAuthenticationToken(customUserDetails, null, customUserDetails.getAuthorities());
                usernamePasswordAuthenticationToken
                        .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // SecurityContext에 인증 정보 설정
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
        }

        // 필터 체인 계속 진행
        filterChain.doFilter(request, response);
    }
}
