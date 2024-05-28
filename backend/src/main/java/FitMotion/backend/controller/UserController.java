package FitMotion.backend.controller;

import FitMotion.backend.dto.request.RequestLoginDTO;
import FitMotion.backend.dto.request.RequestSignUpDTO;
import FitMotion.backend.dto.response.ResponseLoginDTO;
import FitMotion.backend.dto.response.ResponseLogoutDTO;
import FitMotion.backend.dto.update.UpdateUserProfileDTO;
import FitMotion.backend.exception.InvalidPasswordException;
import FitMotion.backend.exception.UserNotFoundException;
import FitMotion.backend.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * 회원가입
     */
    @PostMapping("/signup")
    public ResponseEntity<String> signUp(@RequestBody RequestSignUpDTO signUpDTO) {
        try {
            String result = userService.SignUp(signUpDTO);
            if ("Email already exists".equals(result)) {
                return new ResponseEntity<>(result, HttpStatus.BAD_REQUEST);
            }
            return new ResponseEntity<>("회원 가입 성공", HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>("회원 가입 실패", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 로그인
     */
    @PostMapping("/login")
    public ResponseEntity<ResponseLoginDTO> login(@RequestBody RequestLoginDTO dto) {
        try {
            // 로그인 성공 시 응답 생성
            ResponseLoginDTO response = userService.login(dto);
            // 응답 헤더에 JWT 토큰 추가
            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "Bearer " + response.getAccessToken());

            ResponseLoginDTO responseBody = ResponseLoginDTO.builder()
                    .message("로그인 성공")
                    .email(dto.getEmail())
                    .build();

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(response);
        } catch (InvalidPasswordException e) {
            ResponseLoginDTO errorResponse = ResponseLoginDTO.builder()
                    .message("잘못된 비밀번호입니다.")
                    .build();
            return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
        } catch (UserNotFoundException e) {
            ResponseLoginDTO errorResponse = ResponseLoginDTO.builder()
                    .message("존재하지 않는 계정입니다.")
                    .build();
            return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseLoginDTO errorResponse = ResponseLoginDTO.builder()
                    .message("로그인 실패")
                    .build();
            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 로그아웃
     */
    @PostMapping("/logout")
    public ResponseEntity<ResponseLogoutDTO> logout() {
        ResponseLogoutDTO response = ResponseLogoutDTO.builder()
                .status(HttpStatus.OK.value())
                .message("로그아웃 성공")
                .build();
        return ResponseEntity.ok(response);
    }

    /**
     * 개인정보 수정
     */
    @PutMapping("/profile")
    public ResponseEntity<String> updateUserProfile(@RequestBody UpdateUserProfileDTO updateUserProfileDTO) {
        try {
            String result = userService.updateUserProfile(updateUserProfileDTO);
            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("회원 정보 수정 실패", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
