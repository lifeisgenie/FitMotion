package FitMotion.backend.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RequestUpdateDTO {
    private String username;
    private int age;
    private String phone;
    private double height;
    private double weight;
}