package FitMotion.backend.service;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.dto.request.*;
import FitMotion.backend.dto.response.*;
import FitMotion.backend.entity.Exercise;
import FitMotion.backend.entity.FeedbackFile;
import FitMotion.backend.entity.User;
import FitMotion.backend.entity.UserProfile;
import FitMotion.backend.exception.EmailAlreadyExistsException;
import FitMotion.backend.exception.UserNotFoundException;
import FitMotion.backend.jwt.JWTUtil;
import FitMotion.backend.repository.ExerciseRepository;
import FitMotion.backend.repository.FeedbackRepository;
import FitMotion.backend.repository.UserProfileRepository;
import FitMotion.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;
    private final ExerciseRepository exerciseRepository;
    private final FeedbackRepository feedbackRepository;
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
                    .user(user)
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
//    public ResponseLoginDTO login(RequestLoginDTO dto) {
//        try {
//            // 사용자 존재 여부 확인
//            User user = userRepository.findByEmail(dto.getEmail())
//                    .orElseThrow(() -> new UserNotFoundException("존재하지 않는 계정입니다."));
//
//            // 비밀번호 확인
//            if (!bCryptPasswordEncoder.matches(dto.getPassword(), user.getPassword())) {
//                throw new InvalidPasswordException("잘못된 비밀번호입니다.");
//            }
//
//            Authentication authentication = authenticationManager.authenticate(
//                    new UsernamePasswordAuthenticationToken(dto.getEmail(), dto.getPassword())
//            );
//
//            // 인증된 사용자 정보 가져오기
//            CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();
//
//            // access, refresh 토큰 생성
//            String accessToken = jwtUtil.generateAccessToken(customUserDetails.getUsername());
//
//            // 빌더 패턴을 사용하여 ResponseLoginDTO 객체를 생성해 access, refresh 토큰 설정
//            return ResponseLoginDTO.builder()
//                    .statusCode(HttpStatus.OK.value())
//                    .accessToken(accessToken)
//                    .refreshToken(refreshToken)
//                    .message("로그인 성공")
//                    .email(dto.getEmail())
//                    .build();
//        } catch (AuthenticationException e) {
//            throw new RuntimeException("로그인 실패", e);
//        }
//    }

    /**
     * 로그아웃
     */
    public ResponseLogoutDTO logout() {
        try {
            return ResponseLogoutDTO.builder()
                    .status(HttpStatus.OK.value())
                    .message("로그아웃 성공")
                    .build();
        } catch (Exception e) {
            return ResponseLogoutDTO.builder()
                    .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                    .message("로그아웃 실패")
                    .build();
        }
    }

    /**
     * 개인정보 조회
     */
    public ResponseProfileDTO getUserProfile(String email) {
        UserProfile userProfile = userProfileRepository.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        ResponseProfileDTO dto = ResponseProfileDTO.builder()
                .userId(userProfile.getUserId())
                .email(userProfile.getUser().getEmail())
                .username(userProfile.getUsername())
                .age(userProfile.getAge())
                .phone(userProfile.getPhone())
                .height(userProfile.getHeight())
                .weight(userProfile.getWeight())
                .build();

        return dto;
    }

    /**
     * 개인정보 수정
     */
    @Transactional
    public ResponseMessageDTO updateUserProfile(String email, RequestUpdateDTO dto) {
        try {
            UserProfile userProfile = userProfileRepository.findByUserEmail(email)
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

    /**
     * 운동 상세 조회
     */
    public ResponseExerciseDetailDTO getExerciseDetail(String exerciseName) {
        try {
            Optional<Exercise> exerciseOptional = exerciseRepository.findByExerciseName(exerciseName);
            if (exerciseOptional.isPresent()) {
                Exercise exercise = exerciseOptional.get();
                ResponseExerciseDetailDTO.ExerciseData exerciseData = new ResponseExerciseDetailDTO.ExerciseData(
                        exercise.getExerciseName(),
                        exercise.getExerciseCategory(),
                        exercise.getExerciseExplain(),
                        exercise.getExerciseUrl()
                );

                return new ResponseExerciseDetailDTO(200, "운동 상세 조회 성공", exerciseData);
            } else {
                return new ResponseExerciseDetailDTO(404, "운동을 찾을 수 없습니다", null);
            }
        } catch (Exception e) {
            return new ResponseExerciseDetailDTO(500, "운동 조회 실패", null);
        }
    }

    /**
     * 운동 리스트 조회
     */
    public ResponseExerciseListsDTO getAllExercises() {
        try {
            List<Exercise> exercises = exerciseRepository.findAll();
            List<ResponseExerciseListsDTO.ExerciseInfo> exerciseList = exercises.stream()
                    .map(exercise -> new ResponseExerciseListsDTO.ExerciseInfo(
                            exercise.getExerciseName(),
                            exercise.getExerciseCategory(),
                            exercise.getExerciseExplain(),
                            exercise.getExerciseUrl()))
                    .collect(Collectors.toList());

            ResponseExerciseListsDTO.ExerciseData exerciseData = new ResponseExerciseListsDTO.ExerciseData(exerciseList);

            return new ResponseExerciseListsDTO(200, "운동 리스트 조회 성공", exerciseData);
        } catch (Exception e) {
            return new ResponseExerciseListsDTO(500, "운동 리스트 조회 실패", null);
        }
    }

    /**
     * 피드백 상세 조회
     */
    public ResponseFeedbackDetailDTO getFeedbackDetail(Long feedbackId) {
        Optional<FeedbackFile> feedbackOptional = feedbackRepository.findById(feedbackId);
        if (feedbackOptional.isPresent()) {
            FeedbackFile feedback = feedbackOptional.get();
            ResponseFeedbackDetailDTO.FeedbackData feedbackData = new ResponseFeedbackDetailDTO.FeedbackData(
                    feedback.getFeedbackId(),
                    feedback.getExercise().getExerciseId(),
                    feedback.getVideoUrl(),
                    feedback.getCreatedDate()
            );
            return new ResponseFeedbackDetailDTO(200, "피드백 조회 성공", feedbackData);
        } else {
            return new ResponseFeedbackDetailDTO(500, "피드백 조회 실패", null);
        }
    }

    /**
     * 피드백 리스트 조회
     */
    public List<ResponseFeedbackListDTO.FeedbackInfo> getFeedbackListByUserId(Long userId) {
        List<FeedbackFile> feedbackFiles = feedbackRepository.findByUserId(userId);
        return feedbackFiles.stream()
                .map(feedback -> new ResponseFeedbackListDTO.FeedbackInfo(
                        feedback.getFeedbackId(),
                        feedback.getExercise().getExerciseId(),
                        feedback.getCreatedDate()
                ))
                .collect(Collectors.toList());
    }
}
