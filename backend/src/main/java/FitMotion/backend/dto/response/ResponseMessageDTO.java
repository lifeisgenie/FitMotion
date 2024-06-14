package FitMotion.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
public class ResponseMessageDTO {
    private int statusCode;
    private String message;
}
