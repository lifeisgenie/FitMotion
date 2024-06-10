package FitMotion.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class User {
    @Id
    @Column(name = "email")
    private String email;

    @Column(name = "password", nullable = false)
    private String password;
}
