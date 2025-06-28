package com.catalogotech.pdp.dto.produto;

import com.catalogotech.pdp.domain.Produto.Produto;

import java.time.LocalDate;

public record DadosDetalhamentoProduto(
        Long id,
        String codigo,
        String nome,
        String descricao,
        String foto,
        LocalDate data,
        Boolean ativo,
        String categoria,
        String fornecedor,
        Integer quantidadeVariacoes
) {
    public DadosDetalhamentoProduto(Produto produto) {
        this(
                produto.getId(),
                produto.getCodigo(),
                produto.getNome(),
                produto.getDescricao(),
                produto.getFoto(),
                produto.getData(),
                produto.getAtivo(),
                produto.getCategoria() != null ? produto.getCategoria().getNome() : null,
                produto.getFornecedor() != null ? produto.getFornecedor().getNome() : null,
                produto.getVariacoes() != null ? produto.getVariacoes().size() : 0
        );
    }
}