package org.arkadipta.the_smart_cab.repository;

import org.arkadipta.the_smart_cab.entity.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DriverRepository extends JpaRepository<Driver, Long> {
    Optional<Driver> findByPhoneAndPassword(String phone, String password);
}
