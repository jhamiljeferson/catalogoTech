package com.catalogotech.pdp.dto.tamanho;

import com.catalogotech.pdp.domain.Tamanho.Tamanho;

public record DadosListagemTamanho(Long id, String nome) {

    public DadosListagemTamanho(Tamanho tamanho) {
        this(tamanho.getId(), tamanho.getNome());
    }
}
