package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface TamanhoRepository extends JpaRepository<Tamanho, Long> {
    List<Tamanho> findAllByAtivoTrue();
    Page<Tamanho> findAllByAtivoTrue(Pageable pageable);
    Optional<Tamanho> findByNomeIgnoreCase(String nome);
    List<Tamanho> findByNomeContainingIgnoreCaseAndAtivoTrue(String nome);
    
    @Query("SELECT CASE WHEN COUNT(v) > 0 THEN true ELSE false END FROM Variacao v WHERE v.tamanho.id = :tamanhoId AND v.ativo = true")
    boolean existeVariacaoAtiva(Long tamanhoId);
}
