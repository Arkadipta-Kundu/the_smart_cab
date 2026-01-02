package org.arkadipta.the_smart_cab.repository;

import org.arkadipta.the_smart_cab.entity.Ride;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RideRepository extends JpaRepository<Ride, Long> {
}
