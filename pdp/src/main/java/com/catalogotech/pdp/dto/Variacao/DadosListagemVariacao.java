package com.catalogotech.pdp.dto.Variacao;

import com.catalogotech.pdp.domain.Variacao.Variacao;

import java.math.BigDecimal;

public record DadosListagemVariacao(
        Long id,
        String produto,
        String cor,
        String tamanho,
        Integer quantidade,
        BigDecimal valorVenda,
        String sku
) {
    public DadosListagemVariacao(Variacao v) {
        this(v.getId(), v.getProduto().getNome(), v.getCor().getNome(), v.getTamanho().getNome(),
                v.getQuantidade(), v.getValorVenda(), v.getSku());
    }
}
