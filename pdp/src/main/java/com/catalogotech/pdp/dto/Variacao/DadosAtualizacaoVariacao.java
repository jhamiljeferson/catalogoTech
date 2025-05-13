package com.catalogotech.pdp.dto.Variacao;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

public record DadosAtualizacaoVariacao(

        @Min(value = 0, message = "A quantidade não pode ser negativa.")
        Integer quantidade,

        @DecimalMin(value = "0.0", inclusive = false, message = "O valor de venda deve ser maior que zero.")
        BigDecimal valorVenda,

        @DecimalMin(value = "0.0", inclusive = false, message = "O valor de compra deve ser maior que zero.")
        BigDecimal valorCompra,

        @Min(value = 0, message = "O nível de estoque não pode ser negativo.")
        Integer nivelEstoque,

        @DecimalMin(value = "0.0", inclusive = true, message = "O valor de atacado não pode ser negativo.")
        BigDecimal valorAtacado,

        @DecimalMin(value = "0.0", inclusive = true, message = "O lucro não pode ser negativo.")
        BigDecimal lucro,

        @Size(min = 1, max = 50, message = "O SKU deve ter entre 1 e 50 caracteres.")
        String sku
) {}

