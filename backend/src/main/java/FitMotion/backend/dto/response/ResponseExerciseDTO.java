package FitMotion.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ResponseExerciseDTO {
    private int statusCode;
    private String message;
    private List<ExerciseInfo> exerciseList;

    @Data
    @AllArgsConstructor
    public static class ExerciseInfo {
        private String exerciseName;
        private String exerciseCategory;
        private String exerciseExplain;
        private String exerciseUrl;
    }
}
