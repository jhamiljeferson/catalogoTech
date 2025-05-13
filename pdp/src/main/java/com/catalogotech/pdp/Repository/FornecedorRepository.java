package com.catalogotech.pdp.Repository;

import com.catalogotech.pdp.domain.Fornecedor.Fornecedor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FornecedorRepository extends JpaRepository<Fornecedor, Long> {
    Page<Fornecedor> findAllByAtivoTrue(Pageable pageable);
}
