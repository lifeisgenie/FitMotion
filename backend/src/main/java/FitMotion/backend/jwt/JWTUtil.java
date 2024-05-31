package FitMotion.backend.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JWTUtil {

    private final SecretKey secretKey;

    @Value("${jwt.access-token-expiration}")
    private Long accessTokenExpiration;

    @Value("${jwt.refresh-token-expiration}")
    private Long refreshTokenExpiration;

    // application.properties에서 secret 값 가져와서 secretkey에 저장
    public JWTUtil(@Value("${spring.jwt.secret}") String secret) {
        secretKey = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
    }

    /**
     * 이메일 기반으로 토큰 생성
     * */
    public String generateAccessToken(String email) {
        return createToken(email, accessTokenExpiration);
    }

    public String generateRefreshToken(String email) {
        return createToken(email, refreshTokenExpiration);
    }

    // User 정보를 가지고 AccessToken, RefreshToken을 생성
    public String createToken(String email, Long expiredMs) {
        return Jwts.builder()
                .claim("email", email)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + expiredMs))
                .signWith(secretKey)
                .compact();
    }

    /**
     * 각각의 메소드는 토큰을 전달받아 내부의 Jwts.parser()를 이용해서 내부 데이터를 확인 후 추출.
     * */

    // 모든 클레임 추출
    public Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    // 이메일 추출
    public String extractEmail(String token) {
        return extractAllClaims(token).get("email", String.class);
    }

    // 토큰 만료 시간 추출
    public Date extractExpiration(String token) {
        return extractAllClaims(token).getExpiration();
    }

    // 토큰 만료 여부 확인
    public Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    // 토큰 유효성 검증
    public Boolean validateToken(String token, String email) {
        String extractEmail = extractEmail(token);
        return (extractEmail.equals(email) && !isTokenExpired(token));
    }
}