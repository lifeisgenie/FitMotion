package FitMotion.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;

@Data
@AllArgsConstructor
public class ResponseFeedbackDTO {
    private Long feedbackId;
    private Long userId;
    private Long exerciseId;
    private String videoUrl;
    private Date createdDate;
}
