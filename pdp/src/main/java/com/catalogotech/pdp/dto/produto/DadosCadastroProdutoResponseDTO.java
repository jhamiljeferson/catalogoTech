package com.catalogotech.pdp.dto.produto;

import com.catalogotech.pdp.domain.Produto.Produto;

import java.time.LocalDate;
import java.util.List;

public record DadosCadastroProdutoResponseDTO(
        Long id,
        String codigo,
        String nome,
        String descricao,
        String foto,
        LocalDate data,
        Boolean ativo,
        String categoria,
        String fornecedor,
        Integer quantidadeVariacoes,
        List<String> cores,
        List<String> tamanhos
) {
    public DadosCadastroProdutoResponseDTO(Produto produto) {
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
                produto.getVariacoes() != null ? produto.getVariacoes().size() : 0,
                produto.getVariacoes() != null ? 
                    produto.getVariacoes().stream()
                        .map(v -> v.getCor().getNome())
                        .distinct()
                        .toList() : List.of(),
                produto.getVariacoes() != null ? 
                    produto.getVariacoes().stream()
                        .map(v -> v.getTamanho().getNome())
                        .distinct()
                        .toList() : List.of()
        );
    }
} 