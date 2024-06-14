package FitMotion.backend.repository;

import FitMotion.backend.entity.Exercise;
import FitMotion.backend.entity.UserProfile;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ExerciseRepository extends JpaRepository<Exercise, Integer> {
    Optional<Exercise> findByExerciseName(String exerciseName);
    
    Optional<Exercise> findByExerciseId(Long exerciseId);
    
//    Exercise findByExercise(Long exerciseId);
    @Query("select e from Exercise e where e.exerciseId = :exerciseId")
    Exercise findByExercise(@Param("exerciseId") Long exerciseId);
    
}
