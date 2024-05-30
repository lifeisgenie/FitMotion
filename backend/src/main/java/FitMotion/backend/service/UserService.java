package FitMotion.backend.service;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.dto.request.RequestLoginDTO;
import FitMotion.backend.dto.request.RequestSignUpDTO;
import FitMotion.backend.dto.response.ResponseLoginDTO;
import FitMotion.backend.dto.response.ResponseLogoutDTO;
import FitMotion.backend.dto.response.ResponseMessageDTO;
import FitMotion.backend.dto.request.RequestUpdateDTO;
import FitMotion.backend.entity.User;
import FitMotion.backend.entity.UserProfile;
import FitMotion.backend.exception.EmailAlreadyExistsException;
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
    @Transactional
    public ResponseMessageDTO signUp(RequestSignUpDTO dto) {
        String email = dto.getEmail();
        Boolean isExist = userRepository.existsByEmail(email);

        // 이메일이 이미 존재하는지 확인
        if (isExist) {
            throw new EmailAlreadyExistsException("Email already exists");
        }

        try {
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

            return new ResponseMessageDTO(HttpStatus.CREATED.value(), "회원 가입 성공");
        } catch (Exception e) {
            // 기타 예외 발생 시
            return new ResponseMessageDTO(HttpStatus.INTERNAL_SERVER_ERROR.value(), "회원 가입 실패");
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

            // 빌더 패턴을 사용하여 ResponseLoginDTO 객체를 생성해 access, refresh 토큰 설정
            return ResponseLoginDTO.builder()
                    .statusCode(HttpStatus.OK.value())
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .message("로그인 성공")
                    .email(dto.getEmail())
                    .build();
        } catch (AuthenticationException e) {
            throw new RuntimeException("로그인 실패", e);
        }
    }

    /**
     * 로그아웃
     */
    public ResponseLogoutDTO logout() {
        try {
            // 로그아웃 로직 (예: 토큰 무효화, 세션 종료 등)
            return ResponseLogoutDTO.builder()
                    .status(HttpStatus.OK.value())
                    .message("로그아웃 성공")
                    .build();
        } catch (Exception e) {
            // 예외 발생 시 로그아웃 실패 메시지 반환
            return ResponseLogoutDTO.builder()
                    .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                    .message("로그아웃 실패")
                    .build();
        }
    }

    /**
     * 개인정보 수정
     */
    @Transactional
    public ResponseMessageDTO updateUserProfile(RequestUpdateDTO dto) {
        try {
            UserProfile userProfile = userProfileRepository.findByEmail(dto.getEmail())
                    .orElseThrow(() -> new UserNotFoundException("User not found"));

            userProfile.setUsername(dto.getUsername());
            userProfile.setAge(dto.getAge());
            userProfile.setPhone(dto.getPhone());
            userProfile.setHeight(dto.getHeight());
            userProfile.setWeight(dto.getWeight());

            userProfileRepository.save(userProfile);

            return new ResponseMessageDTO(HttpStatus.OK.value(), "개인정보 수정 성공");
        } catch (UserNotFoundException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("개인정보 수정 실패", e);
        }
    }
}
