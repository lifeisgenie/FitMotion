package FitMotion.backend.exception;

import FitMotion.backend.dto.response.ResponseExerciseDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ResponseExerciseDTO> handleAllExceptions(Exception ex, WebRequest request) {
        ResponseExerciseDTO response = new ResponseExerciseDTO(500, "서버 에러 발생", null);
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
