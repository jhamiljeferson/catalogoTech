package com.catalogotech.pdp.dto.fornecedor;

import jakarta.validation.constraints.NotNull;

public record DadosAtualizacaoFornecedor(
        String nome,
        String telefone,
        String email,
        String endereco
) {}