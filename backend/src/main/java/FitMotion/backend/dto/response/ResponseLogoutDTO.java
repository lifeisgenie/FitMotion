package FitMotion.backend.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ResponseLogoutDTO {
    private int status;
    private String message;
}
