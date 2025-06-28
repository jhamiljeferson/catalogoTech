package com.catalogotech.pdp.dto.produto;

import jakarta.validation.constraints.Size;

public record DadosAtualizacaoProduto(
        @Size(min = 2, max = 100, message = "O nome deve ter entre 2 e 100 caracteres")
        String nome,

        @Size(max = 500, message = "A descrição deve ter no máximo 500 caracteres")
        String descricao,

        String foto,
        
        Long categoriaId,

        Long fornecedorId
) {}