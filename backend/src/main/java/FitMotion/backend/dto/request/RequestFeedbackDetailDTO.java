package FitMotion.backend.dto.request;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RequestFeedbackDetailDTO {
	private Long userId;
    private Long exerciseId;
    private String videoUrl;
    private String content;
}
