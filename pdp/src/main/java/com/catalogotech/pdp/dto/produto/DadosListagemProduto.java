package com.catalogotech.pdp.dto.produto;

import com.catalogotech.pdp.domain.Produto.Produto;
import com.catalogotech.pdp.dto.Variacao.VariacaoRequestDTO;

import java.util.List;
import java.util.stream.Collectors;

public record DadosListagemProduto(
        Long id,
        String nome,
        String codigo,
        Long categoriaId,
        Long fornecedorId,
        String foto,
        List<String> cores,
        List<String> tamanhos,
        List<VariacaoRequestDTO> variacoes
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
                        .map(v -> new VariacaoRequestDTO(
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
/*
public record DadosListagemProduto(
        Long id,
        String nome,
        String codigo

) {
    public DadosListagemProduto(Produto produto) {
        this(   produto.getId(),
                produto.getNome(),
                produto.getCodigo()
        );
    }
}
*/