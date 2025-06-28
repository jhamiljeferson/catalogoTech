package com.catalogotech.pdp.dto.Variacao;

import com.catalogotech.pdp.domain.Variacao.Variacao;
import java.math.BigDecimal;

public record DadosDetalhamentoVariacao(
    Long id,
    String cor,
    String tamanho,
    Integer quantidade,
    BigDecimal valorVenda,
    BigDecimal valorCompra,
    BigDecimal valorAtacado,
    BigDecimal lucro,
    String sku,
    Boolean ativo
) {
    public DadosDetalhamentoVariacao(Variacao v) {
        this(
            v.getId(),
            v.getCor() != null ? v.getCor().getNome() : null,
            v.getTamanho() != null ? v.getTamanho().getNome() : null,
            v.getQuantidade(),
            v.getValorVenda(),
            v.getValorCompra(),
            v.getValorAtacado(),
            v.getLucro(),
            v.getSku(),
            v.getAtivo()
        );
    }
}