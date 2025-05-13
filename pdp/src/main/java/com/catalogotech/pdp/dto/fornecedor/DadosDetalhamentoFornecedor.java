package com.catalogotech.pdp.dto.fornecedor;

import com.catalogotech.pdp.domain.Fornecedor.Fornecedor;
import com.catalogotech.pdp.domain.Fornecedor.TipoPessoa;

import java.time.LocalDate;

public record DadosDetalhamentoFornecedor(
        Long id,
        String nome,
        String cpf,
        String telefone,
        String email,
        String endereco,
        LocalDate data,
        TipoPessoa tipoPessoa
) {
    public DadosDetalhamentoFornecedor(Fornecedor fornecedor) {
        this(
                fornecedor.getId(),
                fornecedor.getNome(),
                fornecedor.getCpf(),
                fornecedor.getTelefone(),
                fornecedor.getEmail(),
                fornecedor.getEndereco(),
                fornecedor.getData(),
                fornecedor.getTipoPessoa()
        );
    }
}
