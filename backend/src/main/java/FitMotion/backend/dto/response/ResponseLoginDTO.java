package FitMotion.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ResponseLoginDTO {
    private int statusCode;
    private String message;
    private LoginSuccessData data;

    @Data
    public static class LoginSuccessData {
        private String email;

        public LoginSuccessData(String email) {
            this.email = email;
        }

        // getters and setters
    }
}
