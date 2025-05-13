package com.catalogotech.pdp.dto.Variacao;

import java.math.BigDecimal;

public record VariacaoRequestDTO(
        String cor,
        String tamanho,
        Integer quantidade,
        BigDecimal preco,
        BigDecimal valorCompra,
        BigDecimal valorAtacado,
        BigDecimal lucro,
        String sku
) {}
