package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TamanhoRepository extends JpaRepository<Tamanho, Long> {
    List<Tamanho> findAllByAtivoTrue();
    Optional<Tamanho> findByNomeIgnoreCase(String nome);
}
