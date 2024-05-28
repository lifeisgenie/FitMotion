package FitMotion.backend.service;

import FitMotion.backend.dto.CustomUserDetails;
import FitMotion.backend.entity.User;
import FitMotion.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    // 사용자 이메일로 사용자 세부 정보 로드
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {

        User userData = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));

        return new CustomUserDetails(userData);
    }
}