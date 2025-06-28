package com.catalogotech.pdp.dto.produto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record DadosCadastroProduto(
        @NotBlank(message = "O código é obrigatório")
        @Size(min = 3, max = 50, message = "O código deve ter entre 3 e 50 caracteres")
        String codigo,

        @NotBlank(message = "O nome é obrigatório")
        @Size(min = 2, max = 100, message = "O nome deve ter entre 2 e 100 caracteres")
        String nome,

        @Size(max = 500, message = "A descrição deve ter no máximo 500 caracteres")
        String descricao,

        String foto,

        @NotNull(message = "O ID da categoria é obrigatório")
        Long categoriaId,

        @NotNull(message = "O ID do fornecedor é obrigatório")
        Long fornecedorId
) {}