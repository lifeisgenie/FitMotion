package FitMotion.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.Date;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FeedbackFile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "feedback_id")
    private int feedbackId;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "userId")
    private UserProfile userProfile;

    @ManyToOne
    @JoinColumn(name = "exercise_id", referencedColumnName = "exercise_id")
    private Exercise exercise;

    @Column(name = "feedback_count")
    private int feedbackCount;

    @Column(name = "video_url")
    private String videoUrl;

    @Column(name = "feedback_content")
    private String feedbackContent;

    @Column(name = "created_date")
    private Date createdDate;
}
