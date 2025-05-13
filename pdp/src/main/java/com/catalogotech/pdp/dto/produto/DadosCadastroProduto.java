package com.catalogotech.pdp.dto.produto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record DadosCadastroProduto(
        @NotBlank(message = "O código é obrigatório")
        String codigo,

        @NotBlank(message = "O nome é obrigatório")
        String nome,

        @Size(max = 255, message = "A descrição deve ter no máximo 255 caracteres")
        String descricao,

        String foto,

        @NotNull(message = "O ID da categoria é obrigatório")
        Long categoriaId,

        @NotNull(message = "O ID do fornecedor é obrigatório")
        Long fornecedorId
) {}