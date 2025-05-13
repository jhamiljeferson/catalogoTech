package com.catalogotech.pdp.dto.Variacao;


import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record DadosCadastroVariacao(

        @NotNull(message = "O ID do produto é obrigatório.")
        Long produtoId,

        @NotNull(message = "O ID da cor é obrigatório.")
        Long corId,

        @NotNull(message = "O ID do tamanho é obrigatório.")
        Long tamanhoId,

        @NotNull(message = "A quantidade é obrigatória.")
        @Min(value = 0, message = "A quantidade não pode ser negativa.")
        Integer quantidade,

        @NotNull(message = "O valor de venda é obrigatório.")
        @DecimalMin(value = "0.0", inclusive = false, message = "O valor de venda deve ser maior que zero.")
        BigDecimal valorVenda,

        @NotNull(message = "O valor de compra é obrigatório.")
        @DecimalMin(value = "0.0", inclusive = false, message = "O valor de compra deve ser maior que zero.")
        BigDecimal valorCompra,

        @NotNull(message = "O nível de estoque é obrigatório.")
        Integer nivelEstoque,

        @NotNull(message = "O valor de atacado é obrigatório.")
        BigDecimal valorAtacado,

        @NotNull(message = "O lucro é obrigatório.")
        BigDecimal lucro,

        @NotBlank(message = "O SKU é obrigatório.")
        String sku
) {}