package com.catalogotech.pdp.dto.produto;


import com.catalogotech.pdp.dto.Variacao.reaproveitar.DadosCadastroVariacaoRequestDTO;

import java.util.List;

public record DadosCadastroProdutoRequestDTO(
        String nome,
        String descricao,
        String codigo,
        Long categoriaId,
        Long fornecedorId,
        String foto,
        List<String> cores,
        List<String> tamanhos,
        List<DadosCadastroVariacaoRequestDTO> variacoes
) {}

