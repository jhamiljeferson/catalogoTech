package com.catalogotech.pdp.dto.fornecedor;

import com.catalogotech.pdp.domain.Fornecedor.Fornecedor;
import com.catalogotech.pdp.domain.Fornecedor.TipoPessoa;

public record DadosListagemFornecedor(
        Long id,
        String nome,
        String telefone,
        String email,
        TipoPessoa tipoPessoa
) {
    public DadosListagemFornecedor(Fornecedor fornecedor) {
        this(   fornecedor.getId(),
                fornecedor.getNome(),
                fornecedor.getTelefone(),
                fornecedor.getEmail(),
                fornecedor.getTipoPessoa());
    }
}
