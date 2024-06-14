package FitMotion.backend.repository;

import FitMotion.backend.entity.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserProfileRepository extends JpaRepository<UserProfile, Long> {
    @Query("SELECT u FROM UserProfile u WHERE u.user.email = :email")
    Optional<UserProfile> findByUserEmail(@Param("email") String email);
    
    @Query("SELECT u FROM UserProfile u WHERE u.userId = :userId")
    UserProfile findByUserId(@Param("userId") Long userId);
    
    @Query("SELECT u.userId FROM UserProfile u WHERE u.user.email = :email")
    Optional<Long> findUserIdByEmail(@Param("email") String email);
}
