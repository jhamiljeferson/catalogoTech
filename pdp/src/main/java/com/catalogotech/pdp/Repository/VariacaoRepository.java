package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.Variacao.Variacao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VariacaoRepository extends JpaRepository<Variacao, Long> {
}