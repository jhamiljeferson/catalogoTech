package com.catalogotech.pdp.dto.cor;

import jakarta.validation.constraints.NotBlank;

public record DadosAtualizacaoCor(
        @NotBlank(message = "O nome da cor é obrigatório.")
        String nome
) {}