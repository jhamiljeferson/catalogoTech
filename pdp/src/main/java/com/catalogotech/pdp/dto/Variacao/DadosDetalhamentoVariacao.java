package com.catalogotech.pdp.dto.Variacao;

import com.catalogotech.pdp.domain.Variacao.Variacao;

import java.math.BigDecimal;

public record DadosDetalhamentoVariacao(
        Long id,
        String produto,
        String cor,
        String tamanho,
        Integer quantidade,
        BigDecimal valorVenda,
        BigDecimal valorCompra,
        Integer nivelEstoque,
        BigDecimal valorAtacado,
        BigDecimal lucro,
        String sku
) {
    public DadosDetalhamentoVariacao(Variacao v) {
        this(v.getId(), v.getProduto().getNome(), v.getCor().getNome(), v.getTamanho().getNome(),
                v.getQuantidade(), v.getValorVenda(), v.getValorCompra(), v.getNivelEstoque(),
                v.getValorAtacado(), v.getLucro(), v.getSku());
    }
}