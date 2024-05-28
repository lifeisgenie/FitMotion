package FitMotion.backend.dto.update;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUserProfileDTO {
    private String email;
    private String username;
    private int age;
    private String phone;
    private String gender;
    private double height;
    private double weight;
}