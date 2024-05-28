package FitMotion.backend.service;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.dto.request.RequestLoginDTO;
import FitMotion.backend.dto.request.RequestSignUpDTO;
import FitMotion.backend.dto.response.ResponseLoginDTO;
import FitMotion.backend.dto.response.ResponseLogoutDTO;
import FitMotion.backend.dto.update.UpdateUserProfileDTO;
import FitMotion.backend.entity.User;
import FitMotion.backend.entity.UserProfile;
import FitMotion.backend.exception.InvalidPasswordException;
import FitMotion.backend.exception.UserNotFoundException;
import FitMotion.backend.jwt.JWTUtil;
import FitMotion.backend.repository.UserProfileRepository;
import FitMotion.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final JWTUtil jwtUtil;
    private final AuthenticationManager authenticationManager;

    /**
     * 회원가입
     */
    public String SignUp(RequestSignUpDTO dto) {
        try {
            String email = dto.getEmail();
            Boolean isExist = userRepository.existsByEmail(email);

            // 이메일이 이미 존재하는지 확인
            if (isExist) {
                return "Email already exists";
            }

            // 사용자 정보 저장
            User user = User.builder()
                    .email(dto.getEmail())
                    .password(bCryptPasswordEncoder.encode(dto.getPassword()))
                    .build();
            userRepository.save(user);

            // 사용자 프로필 정보 저장
            UserProfile userProfile = UserProfile.builder()
                    .email(dto.getEmail())
                    .username(dto.getUsername())
                    .age(dto.getAge())
                    .phone(dto.getPhone())
                    .height(dto.getHeight())
                    .weight(dto.getWeight())
                    .build();

            // 새로운 사용자 객체를 저장소에 저장
            userProfileRepository.save(userProfile);

            return "회원 가입 성공";
        } catch (Exception e) {
            throw new RuntimeException("회원 가입 실패", e);
        }
    }

    /**
     * 로그인
     */
    public ResponseLoginDTO login(RequestLoginDTO dto) {

        try {
            // 사용자 존재 여부 확인
            User user = userRepository.findByEmail(dto.getEmail())
                    .orElseThrow(() -> new UserNotFoundException("존재하지 않는 계정입니다."));

            // 비밀번호 확인
            if (!bCryptPasswordEncoder.matches(dto.getPassword(), user.getPassword())) {
                throw new InvalidPasswordException("잘못된 비밀번호입니다.");
            }

            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(dto.getEmail(), dto.getPassword())
            );

            // 인증된 사용자 정보 가져오기
            CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();
            // access, refresh 토큰 생성
            String accessToken = jwtUtil.generateAccessToken(customUserDetails.getUsername());
            String refreshToken = jwtUtil.generateRefreshToken(customUserDetails.getUsername());

            // 빌터 패턴을 사용하여 ResponseLoginDTO 객체를 생성해 access, refresh 토큰 설정
            return ResponseLoginDTO.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .build(); // 객체를 빌드하여 반환.
        } catch (AuthenticationException e) { // 인증 과정에서 예외가 발생하면(잘못된 이메일 또는 비밀번호) 예외를 개치
            throw new RuntimeException("로그인 실패", e);
        }
    }

    /**
     * 로그아웃
     */
    public ResponseLogoutDTO logout() {
        // 로그아웃 로직 추가 필요 (토큰 블랙리스트 또는 클라이언트 측에서 처리)
        // 여기서는 단순히 성공 메시지를 반환
        return ResponseLogoutDTO.builder()
                .status(HttpStatus.OK.value())
                .message("로그아웃 성공")
                .build();
    }

    /**
     * 개인정보 수정
     */
    @Transactional
    public String updateUserProfile(UpdateUserProfileDTO dto) {
        try {
            UserProfile userProfile = userProfileRepository.findByEmail(dto.getEmail())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            userProfile.setUsername(dto.getUsername());
            userProfile.setAge(dto.getAge());
            userProfile.setPhone(dto.getPhone());
            userProfile.setHeight(dto.getHeight());
            userProfile.setWeight(dto.getWeight());

            userProfileRepository.save(userProfile);

            return "User profile updated successfully";
        } catch (Exception e) {
            throw new RuntimeException("User profile update failed", e);
        }
    }
}
