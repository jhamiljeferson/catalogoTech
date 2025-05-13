package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.cargos.Cargos;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CargosRepository extends JpaRepository<Cargos, Long> {
}