package com.catalogotech.pdp.dto.CategoriaDTO;

import com.catalogotech.pdp.domain.Categoria.Categoria;

public record DadosListagemCategoria(
        Long id,
        String nome,
        Boolean ativo

) {
    public DadosListagemCategoria(Categoria categoria) {
        this(categoria.getId(), categoria.getNome(), categoria.getAtivo());
    }
}
