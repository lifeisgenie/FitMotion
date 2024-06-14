package FitMotion.backend.service;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.entity.User;
import FitMotion.backend.repository.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 구현 방법은 DB에서 특정 User를 조회해서 리턴을 해야 되므로 DB 연결을 진행
    // DB에 접근할 리포지토리 객체 UserRepository 변수 선언
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {

        // DB에서 User 테이블의 데이터를 가져옴
        // userData를 통해서 userRepository에 findByEmail 메소드에 인자로 받은 email으로 조회
        User userData = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        // UserDetails에 담아서 return하면 AutneticationManager가 검증 함
        return new CustomUserDetails(userData);
    }
}