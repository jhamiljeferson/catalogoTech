package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.Cor.Cor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CorRepository extends JpaRepository<Cor, Long> {
    List<Cor> findAllByAtivoTrue();
    Optional<Cor> findByNomeIgnoreCase(String nome);
}
