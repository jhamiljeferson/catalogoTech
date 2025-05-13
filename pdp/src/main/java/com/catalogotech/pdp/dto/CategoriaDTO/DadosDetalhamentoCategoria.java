package com.catalogotech.pdp.dto.CategoriaDTO;

import com.catalogotech.pdp.domain.Categoria.Categoria;

public record DadosDetalhamentoCategoria(
        Long id,
        String nome
) {
    public DadosDetalhamentoCategoria(Categoria categoria) {
        this(categoria.getId(), categoria.getNome());
    }
}