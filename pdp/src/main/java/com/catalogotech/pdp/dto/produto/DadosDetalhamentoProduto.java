package com.catalogotech.pdp.dto.produto;

import com.catalogotech.pdp.domain.Categoria.Categoria;
import com.catalogotech.pdp.domain.Fornecedor.Fornecedor;
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
        Categoria categoria,
        Fornecedor fornecedor
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
                produto.getCategoria(),
                produto.getFornecedor()
        );
    }
}