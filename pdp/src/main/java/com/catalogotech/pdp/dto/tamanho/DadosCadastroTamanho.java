package com.catalogotech.pdp.dto.tamanho;

import jakarta.validation.constraints.NotBlank;

public record DadosCadastroTamanho(
        @NotBlank(message = "O nome do tamanho é obrigatório.")
        String nome
) {}