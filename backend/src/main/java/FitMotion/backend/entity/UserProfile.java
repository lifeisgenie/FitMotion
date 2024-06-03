package FitMotion.backend.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    @OneToOne
    @JoinColumn(name = "email", referencedColumnName = "email", nullable = false)
    @JsonManagedReference
    private User user;

    private String username;
    private int age;
    private String phone;
    private double height;
    private double weight;
}
