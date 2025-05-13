package com.catalogotech.pdp.dto.cor;

import com.catalogotech.pdp.domain.Cor.Cor;

public record DadosListagemCor(Long id, String nome) {
    public DadosListagemCor(Cor cor) {
        this(cor.getId(), cor.getNome());
    }
}
