package com.catalogotech.pdp.dto.Variacao;

import com.catalogotech.pdp.domain.Produto.Produto;

import java.time.LocalDate;
import java.util.List;

public record DadosDetalhamentoProdutoComVariacoes(
    Long id,
    String codigo,
    String nome,
    String descricao,
    String foto,
    LocalDate data,
    Boolean ativo,
    String categoria,
    String fornecedor,
    List<DadosDetalhamentoVariacao> variacoes
) {
    public DadosDetalhamentoProdutoComVariacoes(Produto produto) {
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
            produto.getVariacoes() != null
                ? produto.getVariacoes().stream().map(DadosDetalhamentoVariacao::new).toList()
                : List.of()
        );
    }
}