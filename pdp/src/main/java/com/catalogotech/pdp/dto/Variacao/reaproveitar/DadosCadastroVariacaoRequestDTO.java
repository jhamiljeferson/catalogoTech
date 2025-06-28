package com.catalogotech.pdp.dto.Variacao.reaproveitar;

import java.math.BigDecimal;

public record DadosCadastroVariacaoRequestDTO(
        String cor,
        String tamanho,
        Integer quantidade,
        BigDecimal preco,
        BigDecimal valorCompra,
        BigDecimal valorAtacado,
        BigDecimal lucro,
        String sku

) { }
