package FitMotion.backend.dto.response;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
public class ResponseUserProfile {
	private int statusCode;
    private String message;
    private userProfile data;
    @Data
    @AllArgsConstructor
	public static class userProfile{
		private Long id;
		private int age;
		private double height;
		private double weight;
		private String username;
		private String phone;
	}
}

