package com.catalogotech.pdp.dto.produto;

import com.catalogotech.pdp.domain.Produto.Produto;

import java.util.List;
import java.util.stream.Collectors;
/*
public record DadosListagemProduto(
        Long id,
        String nome,
        String codigo,
        Long categoriaId,
        Long fornecedorId,
        String foto,
        List<String> cores,
        List<String> tamanhos,
        List<DadosCadastroVariacao.VariacaoRequestDTO> variacoes
) {
    public DadosListagemProduto(Produto produto) {
        this(
                produto.getId(),
                produto.getNome(),
                produto.getCodigo(),
                produto.getCategoria().getId(),
                produto.getFornecedor().getId(),
                produto.getFoto(),
                produto.getVariacoes().stream()
                        .map(v -> v.getCor().getNome())
                        .distinct()
                        .collect(Collectors.toList()),
                produto.getVariacoes().stream()
                        .map(v -> v.getTamanho().getNome())
                        .distinct()
                        .collect(Collectors.toList()),
                produto.getVariacoes().stream()
                        .map(v -> new DadosCadastroVariacao.VariacaoRequestDTO(
                                v.getCor().getNome(),
                                v.getTamanho().getNome(),
                                v.getQuantidade(),
                                v.getValorVenda(),
                                v.getValorCompra(),
                                v.getValorAtacado(),
                                v.getLucro(),
                                v.getSku()
                        ))
                        .collect(Collectors.toList())
        );
    }
}
*/

public record DadosListagemProduto(
        Long id,
        String nome,
        String codigo,
        String foto,
        String categoria,
        String fornecedor,
        Boolean ativo,
        Integer quantidadeVariacoes,
        List<String> cores,
        List<String> tamanhos
) {
    public DadosListagemProduto(Produto produto) {
        this(
                produto.getId(),
                produto.getNome(),
                produto.getCodigo(),
                produto.getFoto(),
                produto.getCategoria() != null ? produto.getCategoria().getNome() : null,
                produto.getFornecedor() != null ? produto.getFornecedor().getNome() : null,
                produto.getAtivo(),
                produto.getVariacoes() != null ? produto.getVariacoes().size() : 0,
                produto.getVariacoes() != null ? 
                    produto.getVariacoes().stream()
                        .map(v -> v.getCor() != null ? v.getCor().getNome() : null)
                        .filter(cor -> cor != null)
                        .distinct()
                        .collect(Collectors.toList()) : List.of(),
                produto.getVariacoes() != null ? 
                    produto.getVariacoes().stream()
                        .map(v -> v.getTamanho() != null ? v.getTamanho().getNome() : null)
                        .filter(tamanho -> tamanho != null)
                        .distinct()
                        .collect(Collectors.toList()) : List.of()
        );
    }
}