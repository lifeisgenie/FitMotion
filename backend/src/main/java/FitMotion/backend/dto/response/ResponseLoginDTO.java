package FitMotion.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResponseLoginDTO {
    private String accessToken;
    private String refreshToken;
    private String message;
    private String email;
}
