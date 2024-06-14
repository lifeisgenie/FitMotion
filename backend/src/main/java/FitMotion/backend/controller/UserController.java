package FitMotion.backend.controller;

import FitMotion.backend.dto.request.*;
import FitMotion.backend.dto.response.*;
import FitMotion.backend.exception.EmailAlreadyExistsException;
//import FitMotion.backend.exception.InvalidPasswordException;
//import FitMotion.backend.exception.UserNotFoundException;
import FitMotion.backend.exception.UserNotFoundException;
import FitMotion.backend.jwt.JWTUtil;
import FitMotion.backend.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final JWTUtil jwtUtil;


    /**
     * 회원가입
     */
    @PostMapping("/signup")
    public ResponseEntity<ResponseMessageDTO> signUp(@RequestBody RequestSignUpDTO dto) {
        try {
            ResponseMessageDTO result = userService.signUp(dto);
            return new ResponseEntity<>(result, HttpStatus.valueOf(result.getStatusCode()));
        } catch (EmailAlreadyExistsException e) {
            return new ResponseEntity<>(new ResponseMessageDTO(HttpStatus.BAD_REQUEST.value(), e.getMessage()), HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            return new ResponseEntity<>(new ResponseMessageDTO(HttpStatus.INTERNAL_SERVER_ERROR.value(), "회원 가입 실패"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 로그인
     */
//    @PostMapping("/login")
//    public ResponseEntity<ResponseLoginDTO> login(@RequestBody RequestLoginDTO dto) {
//        try {
//            ResponseLoginDTO response = userService.login(dto);
//            return ResponseEntity.ok(response);
//        } catch (InvalidPasswordException e) {
//            return new ResponseEntity<>(new ResponseLoginDTO(HttpStatus.UNAUTHORIZED.value(), "잘못된 비밀번호입니다.", null, null, dto.getEmail()), HttpStatus.UNAUTHORIZED);
//        } catch (UserNotFoundException e) {
//            return new ResponseEntity<>(new ResponseLoginDTO(HttpStatus.NOT_FOUND.value(), "존재하지 않는 계정입니다.", null, null, dto.getEmail()), HttpStatus.NOT_FOUND);
//        } catch (Exception e) {
//            return new ResponseEntity<>(new ResponseLoginDTO(HttpStatus.INTERNAL_SERVER_ERROR.value(), "로그인 실패", null, null, dto.getEmail()), HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }

    /**
     * 로그아웃
     */
    @PostMapping("/logout")
    public ResponseEntity<ResponseLogoutDTO> logout() {
        ResponseLogoutDTO response = userService.logout();
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    /**
     * 개인정보 조회
     */
    @GetMapping("/profile/info")
    public ResponseEntity<ResponseProfileDTO> getUserProfile(Authentication authentication) {
        String email = authentication.getName(); // 사용자 인증 정보에서 이메일을 가져옴
        ResponseProfileDTO dto = userService.getUserProfile(email);
        return ResponseEntity.ok(dto);
    }


    /**
     * 개인정보 수정
     */
    @PutMapping("/profile/update")
    public ResponseEntity<ResponseMessageDTO> updateUserProfile(@RequestBody RequestUpdateDTO dto, Authentication authentication) {
        try {
            String email = authentication.getName(); // 사용자 인증 정보에서 이메일을 가져옴
            ResponseMessageDTO result = userService.updateUserProfile(email, dto); // result 변수를 선언 및 초기화
            return new ResponseEntity<>(result, HttpStatus.valueOf(result.getStatusCode()));
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessageDTO(HttpStatus.NOT_FOUND.value(), "사용자를 찾을 수 없습니다."), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(new ResponseMessageDTO(HttpStatus.INTERNAL_SERVER_ERROR.value(), "회원 정보 수정 실패"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 운동 상세 조회
     */
    @GetMapping("/exercise/detail/{exerciseName}")
    public ResponseEntity<ResponseExerciseDetailDTO> getExerciseDetail(@PathVariable String exerciseName) {
        ResponseExerciseDetailDTO response = userService.getExerciseDetail(exerciseName);
        return ResponseEntity.status(response.getStatusCode()).body(response);
    }

    /**
     * 운동 리스트 조회
     */
    @GetMapping("/exercise/list")
    public ResponseEntity<ResponseExerciseListsDTO> getAllExercises() {
        ResponseExerciseListsDTO response = userService.getAllExercises();
        return ResponseEntity.status(response.getStatusCode()).body(response);
    }

    /**
     * 피드백 상세 조회
     */
    @GetMapping("/feedback/detail/{feedbackId}")
    public ResponseEntity<ResponseFeedbackDetailDTO> getFeedbackDetail(@PathVariable Long feedbackId) {
        try {
            ResponseFeedbackDetailDTO response = userService.getFeedbackDetail(feedbackId);
            if (response.getStatusCode() == 200) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseFeedbackDetailDTO(500, "피드백 조회 실패", null));
        }
    }

    /**
     * 피드백 리스트 조회
     */
    @GetMapping("/feedback/list/{userId}")
    public ResponseEntity<ResponseFeedbackListDTO> getFeedbackList(@PathVariable Long userId) {
        try {
            List<ResponseFeedbackListDTO.FeedbackInfo> feedbackList = userService.getFeedbackListByUserId(userId);
            ResponseFeedbackListDTO.FeedbackData data = new ResponseFeedbackListDTO.FeedbackData(feedbackList);
            return ResponseEntity.ok(new ResponseFeedbackListDTO(200, "피드백 리스트 조회 성공", data));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseFeedbackListDTO(500, "피드백 리스트 조회 실패", null));
        }
    }
//    private final JWTUtil jwtUtil;
//
//    @PostMapping("/generate")
//    public ResponseEntity<Map<String, String>> generateToken(@RequestBody Map<String, String> payload) {
//        String email = payload.get("email");
//        if (email == null || email.isEmpty()) {
//            return ResponseEntity.badRequest().body(null);
//        }
//        String accessToken = jwtUtil.generateAccessToken(email);
//        String refreshToken = jwtUtil.generateRefreshToken(email);
//        refreshTokenRepository.save(new RefreshToken(email, refreshToken)); // Refresh Token 저장
//        Map<String, String> response = new HashMap<>();
//        response.put("accessToken", accessToken);
//        response.put("refreshToken", refreshToken);
//        return ResponseEntity.ok(response);
//    }
//
//    @PostMapping("/refresh")
//    public ResponseEntity<Map<String, String>> refreshAccessToken(@RequestBody Map<String, String> payload) {
//        String refreshToken = payload.get("refreshToken");
//        String email = payload.get("email");
//
//        // 저장소에서 Refresh Token을 검증
//        RefreshToken storedRefreshToken = refreshTokenRepository.findByEmail(email);
//        if (storedRefreshToken == null || !storedRefreshToken.getToken().equals(refreshToken)) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
//        }
//
//        // Refresh Token이 만료되지 않았는지 검증
//        if (jwtUtil.isTokenExpired(refreshToken)) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
//        }
//
//        // 새로운 Access Token 발급
//        String newAccessToken = jwtUtil.generateAccessToken(email);
//        Map<String, String> response = new HashMap<>();
//        response.put("accessToken", newAccessToken);
//        return ResponseEntity.ok(response);
//    }
//
//    @GetMapping("/validate")
//    public ResponseEntity<Map<String, String>> validateToken(@RequestParam String token) {
//        Map<String, String> response = new HashMap<>();
//        try {
//            String email = jwtUtil.extractEmail(token);
//            if (jwtUtil.validateToken(token, email)) {
//                response.put("status", "valid");
//                response.put("email", email);
//            } else {
//                response.put("status", "invalid");
//            }
//        } catch (Exception e) {
//            response.put("status", "invalid");
//            response.put("message", e.getMessage());
//        }
//        return ResponseEntity.ok(response);
//    }
}

