package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.Produto.Produto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {
    List<Produto> findAllByAtivoTrue();
    
    Page<Produto> findAllByAtivoTrue(Pageable pageable);
    
    Page<Produto> findByNomeContainingIgnoreCaseAndAtivoTrue(String nome, Pageable pageable);
    
    // Consulta otimizada com JOIN FETCH para carregar variações
    @Query("SELECT DISTINCT p FROM Produto p " +
           "LEFT JOIN FETCH p.variacoes v " +
           "LEFT JOIN FETCH v.cor " +
           "LEFT JOIN FETCH v.tamanho " +
           "WHERE p.ativo = true")
    List<Produto> findAllByAtivoTrueWithVariacoes();
    
    // Consulta paginada com variações
    @Query("SELECT DISTINCT p FROM Produto p " +
           "LEFT JOIN FETCH p.variacoes v " +
           "LEFT JOIN FETCH v.cor " +
           "LEFT JOIN FETCH v.tamanho " +
           "WHERE p.ativo = true")
    Page<Produto> findAllByAtivoTrueWithVariacoes(Pageable pageable);
    
    // Busca por nome com variações
    @Query("SELECT DISTINCT p FROM Produto p " +
           "LEFT JOIN FETCH p.variacoes v " +
           "LEFT JOIN FETCH v.cor " +
           "LEFT JOIN FETCH v.tamanho " +
           "WHERE p.ativo = true AND LOWER(p.nome) LIKE LOWER(CONCAT('%', :nome, '%'))")
    Page<Produto> findByNomeContainingIgnoreCaseAndAtivoTrueWithVariacoes(@Param("nome") String nome, Pageable pageable);
}
