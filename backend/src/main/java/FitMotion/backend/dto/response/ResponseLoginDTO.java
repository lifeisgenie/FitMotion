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
    private int statusCode;
    private String message;
    private String accessToken;
    private String refreshToken;
    private String email;
    private Long id;
}
