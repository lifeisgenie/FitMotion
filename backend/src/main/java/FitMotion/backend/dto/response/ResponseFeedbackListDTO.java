package FitMotion.backend.dto.response;


import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
public class ResponseFeedbackListDTO {
    private int statusCode;
    private String message;
    private FeedbackData data;
    private ResponseExerciseDetailDTO edto;

    @Data
    @AllArgsConstructor
    public static class FeedbackData {
        private List<FeedbackInfo> feedbackList;
    }

    @Data
    @AllArgsConstructor
    public static class FeedbackInfo {
        private Long feedbackId;
        private ResponseExerciseDetailDTO edto;
        private Long exerciseId;
        private Date createdDate;
    }
}
