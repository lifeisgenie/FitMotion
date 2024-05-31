package FitMotion.backend.repository;

import FitMotion.backend.entity.Exercise;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ExerciseRepository extends JpaRepository<Exercise, Integer> {
    Optional<Exercise> findByExerciseName(String exerciseName);
}
