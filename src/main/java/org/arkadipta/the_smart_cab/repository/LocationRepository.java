package org.arkadipta.the_smart_cab.repository;

import org.arkadipta.the_smart_cab.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface LocationRepository extends JpaRepository<Location, Long> {
    Optional<Location> findByLocationCode(Integer locationCode);
}
