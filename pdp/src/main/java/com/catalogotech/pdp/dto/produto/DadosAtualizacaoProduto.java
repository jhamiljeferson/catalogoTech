package com.catalogotech.pdp.dto.produto;

import jakarta.validation.constraints.NotNull;

public record DadosAtualizacaoProduto(

        @NotNull(message = "O ID é obrigatório para atualização")
        Long id,

        @NotNull(message = "O Nome é obrigatório para atualização")
        String nome,

        @NotNull(message = "A Descrição é obrigatório para atualização")
        String descricao,

        String foto,
        @NotNull(message = "O ID da categoria é obrigatório")
        Long categoriaId,

        @NotNull(message = "O ID do fornecedor é obrigatório")
        Long fornecedorId
) {}
