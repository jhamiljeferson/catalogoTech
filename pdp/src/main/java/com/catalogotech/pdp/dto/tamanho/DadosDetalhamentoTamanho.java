package com.catalogotech.pdp.dto.tamanho;

import com.catalogotech.pdp.domain.Tamanho.Tamanho;

public record DadosDetalhamentoTamanho(Long id, String nome) {

    public DadosDetalhamentoTamanho(Tamanho tamanho) {
        this(tamanho.getId(), tamanho.getNome());
    }
}