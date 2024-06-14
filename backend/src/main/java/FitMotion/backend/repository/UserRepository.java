package FitMotion.backend.repository;

import FitMotion.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {

    // 이미 동일한 email이 있으면 회원가입 진행이 안되므로 DB 내부에 특정 User가 존재하는지 확인.
    // email 을 기반으로 User가 존재하는지 확인하는 jpa 구문
    Boolean existsByEmail(String email);

    // email을 받아 DB 테이블에서 회원을 조회하는 메소드 작성
    @Query("SELECT u FROM User u WHERE u.email = :email")
    Optional<User> findByEmail(@Param("email") String email);
}
