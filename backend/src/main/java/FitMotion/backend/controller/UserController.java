package FitMotion.backend.controller;

import FitMotion.backend.dto.request.*;
import FitMotion.backend.dto.response.*;
import FitMotion.backend.entity.UserProfile;
import FitMotion.backend.exception.EmailAlreadyExistsException;
import FitMotion.backend.exception.InvalidPasswordException;
import FitMotion.backend.exception.UserNotFoundException;
import FitMotion.backend.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

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
    @PostMapping("/login")
    public ResponseEntity<ResponseLoginDTO> login(@RequestBody RequestLoginDTO dto) {
        try {
            ResponseLoginDTO response = userService.login(dto);
            return ResponseEntity.ok(response);
        } catch (InvalidPasswordException e) {
            return new ResponseEntity<>(new ResponseLoginDTO(HttpStatus.UNAUTHORIZED.value(), "잘못된 비밀번호입니다.", null, null, dto.getEmail()), HttpStatus.UNAUTHORIZED);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>(new ResponseLoginDTO(HttpStatus.NOT_FOUND.value(), "존재하지 않는 계정입니다.", null, null, dto.getEmail()), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(new ResponseLoginDTO(HttpStatus.INTERNAL_SERVER_ERROR.value(), "로그인 실패", null, null, dto.getEmail()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 로그아웃
     */
    @PostMapping("/logout")
    public ResponseEntity<ResponseLogoutDTO> logout() {
        ResponseLogoutDTO response = userService.logout();
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
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
}
