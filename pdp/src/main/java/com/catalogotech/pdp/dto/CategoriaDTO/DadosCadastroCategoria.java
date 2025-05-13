package com.catalogotech.pdp.dto.CategoriaDTO;

import jakarta.validation.constraints.NotBlank;

public record DadosCadastroCategoria(
        @NotBlank(message = "O nome da categoria é obrigatório.")
        String nome
) {}

