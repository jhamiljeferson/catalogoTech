package com.catalogotech.pdp.dto.cor;

import com.catalogotech.pdp.domain.Cor.Cor;

public record DadosDetalhamentoCor(Long id, String nome) {

    public DadosDetalhamentoCor(Cor cor) {
        this(cor.getId(), cor.getNome());
    }
}