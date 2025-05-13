package com.catalogotech.pdp.dto.tamanho;

import jakarta.validation.constraints.NotNull;

public record DadosAtualizacaoTamanho(
        @NotNull(message = "O Nome do tamanho é obrigatório.")
        String nome
) {}