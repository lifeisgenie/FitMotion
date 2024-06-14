package FitMotion.backend.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JWTUtil {

    private final SecretKey secretKey;

    public JWTUtil(@Value("${spring.jwt.secret}") String secret) {
        // 비밀 키 문자열을 UTF-8 바이트 배열로 변환
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        secretKey = Keys.hmacShaKeyFor(keyBytes);
    }

    // 모든 클레임 추출
    public Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(secretKey) // 비밀 키 설정
                .build() // JwtParser 반환
                .parseClaimsJws(token) // JWT 파싱
                .getBody(); // 클레임 반환
    }

    public String extractEmail(String token) {
        return extractAllClaims(token).get("email", String.class);
    }

    public Boolean isTokenExpired(String token) {
        return extractAllClaims(token).getExpiration().before(new Date());
    }

    // User 정보를 가지고 AccessToken, RefreshToken을 생성
    public String createJwt(String email, Long expiredMs) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expiredMs);

        return Jwts.builder()
                .claim("email", email)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(secretKey, SignatureAlgorithm.HS256)
                .compact();
    }
}
