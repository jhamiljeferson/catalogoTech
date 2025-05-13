package com.catalogotech.pdp.dto.produto;

import com.catalogotech.pdp.dto.Variacao.VariacaoRequestDTO;

import java.util.List;

public record ProdutoRequestDTO(
        String nome,
        String descricao,
        String codigo,
        Long categoriaId,
        Long fornecedorId,
        String foto,
        List<String> cores,
        List<String> tamanhos,
        List<VariacaoRequestDTO> variacoes
) {}

