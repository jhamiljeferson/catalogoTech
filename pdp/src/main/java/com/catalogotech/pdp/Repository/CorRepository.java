package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.Cor.Cor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface CorRepository extends JpaRepository<Cor, Long> {
    List<Cor> findAllByAtivoTrue();
    Page<Cor> findAllByAtivoTrue(Pageable pageable);
    Optional<Cor> findByNomeIgnoreCase(String nome);
    List<Cor> findByNomeContainingIgnoreCaseAndAtivoTrue(String nome);
    
    @Query("SELECT CASE WHEN COUNT(v) > 0 THEN true ELSE false END FROM Variacao v WHERE v.cor.id = :corId AND v.ativo = true")
    boolean existeVariacaoAtiva(Long corId);
}
