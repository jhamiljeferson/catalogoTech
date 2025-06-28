package com.catalogotech.pdp.dto.Variacao;


import com.catalogotech.pdp.domain.Variacao.Variacao;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
public record DadosCadastroVariacao(
        String cor,
        String tamanho,
        Integer quantidade,
        BigDecimal preco,
        BigDecimal valorCompra,
        BigDecimal valorAtacado,
        BigDecimal lucro,
        String sku

) { }
/*
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
) {
        public static record DadosDetalhamentoVariacao(
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
                this(v.getId(), v.getProdutoId().getNome(), v.getCorId().getNome(), v.getTamanhoId().getNome(),
                        v.getQuantidade(), v.getValorVenda(), v.getValorCompra(), v.getNivelEstoque(),
                        v.getValorAtacado(), v.getLucro(), v.getSku());
            }
        }

        public static record DadosListagemVariacao(
                Long id,
                String produto,
                String cor,
                String tamanho,
                Integer quantidade,
                BigDecimal valorVenda,
                String sku
        ) {
            public DadosListagemVariacao(Variacao v) {
                this(v.getId(), v.getProdutoId().getNome(), v.getCorId().getNome(), v.getTamanhoId().getNome(),
                        v.getQuantidade(), v.getValorVenda(), v.getSku());
            }
        }

        public static record VariacaoRequestDTO(
                String cor,
                String tamanho,
                Integer quantidade,
                BigDecimal preco,
                BigDecimal valorCompra,
                BigDecimal valorAtacado,
                BigDecimal lucro,
                String sku
        ) {}
}*/