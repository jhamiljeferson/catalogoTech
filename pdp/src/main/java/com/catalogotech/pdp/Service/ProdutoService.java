package com.catalogotech.pdp.Service;

import com.catalogotech.pdp.Repository.*;
import com.catalogotech.pdp.domain.Cor.Cor;
import com.catalogotech.pdp.domain.Produto.Produto;
import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import com.catalogotech.pdp.domain.Variacao.Variacao;
import com.catalogotech.pdp.dto.Variacao.DadosAtualizacaoVariacao;
import com.catalogotech.pdp.dto.Variacao.DadosDetalhamentoProdutoComVariacoes;
import com.catalogotech.pdp.dto.Variacao.DadosDetalhamentoVariacao;
import com.catalogotech.pdp.dto.Variacao.reaproveitar.DadosCadastroVariacaoRequestDTO;
import com.catalogotech.pdp.dto.produto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;
import java.util.Optional;

@Service
public class ProdutoService {

    @Autowired
    private ProdutoRepository repository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    @Autowired
    private FornecedorRepository fornecedorRepository;

    @Autowired
    private CorRepository corRepository;
    
    @Autowired
    private TamanhoRepository tamanhoRepository;
    
    @Autowired
    private VariacaoRepository variacaoRepository;

    @Transactional
    public ProdutoResponse cadastrar(DadosCadastroProduto dados, UriComponentsBuilder uriBuilder) {
        var categoria = categoriaRepository.getReferenceById(dados.categoriaId());
        var fornecedor = fornecedorRepository.getReferenceById(dados.fornecedorId());

        var produto = new Produto(dados, categoria, fornecedor);
        repository.save(produto);

        URI uri = uriBuilder.path("/produtos/{id}").buildAndExpand(produto.getId()).toUri();
        return new ProdutoResponse(uri, new DadosDetalhamentoProduto(produto));
    }

    public Page<DadosListagemProduto> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrueWithVariacoes(paginacao).map(DadosListagemProduto::new);
    }

    public Page<DadosListagemProduto> buscarPorNome(String nome, Pageable pageable) {
        return repository.findByNomeContainingIgnoreCaseAndAtivoTrueWithVariacoes(nome, pageable)
                .map(DadosListagemProduto::new);
    }

    public DadosDetalhamentoProduto atualizar(Long id, DadosAtualizacaoProduto dados) {
        var produto = repository.getReferenceById(id);

        var categoria = dados.categoriaId() != null ? categoriaRepository.getReferenceById(dados.categoriaId()) : null;
        var fornecedor = dados.fornecedorId() != null ? fornecedorRepository.getReferenceById(dados.fornecedorId()) : null;

        produto.atualizar(dados, categoria, fornecedor);
        return new DadosDetalhamentoProduto(produto);
    }

    public void excluir(Long id) {
        var produto = repository.getReferenceById(id);
        produto.excluir();
    }

    public DadosDetalhamentoProduto detalhar(Long id) {
        var produto = repository.getReferenceById(id);
        return new DadosDetalhamentoProduto(produto);
    }
    //produto com variação
    @Transactional
    public ProdutoComVariacoesResponse cadastrarVariacao(DadosCadastroProdutoRequestDTO dto, UriComponentsBuilder uriBuilder) {
        var categoria = categoriaRepository.getReferenceById(dto.categoriaId());
        var fornecedor = fornecedorRepository.getReferenceById(dto.fornecedorId());

        var produto = new Produto(dto, categoria, fornecedor);
        repository.save(produto);

        criarCoresETamanhos(dto);

        criarVariacoes(dto, produto);

        URI uri = uriBuilder.path("/produtos/{id}").buildAndExpand(produto.getId()).toUri();
        return new ProdutoComVariacoesResponse(uri, new DadosCadastroProdutoResponseDTO(produto));
    }
    //produto com variação
    private void criarCoresETamanhos(DadosCadastroProdutoRequestDTO dto) {
        for (String corNome : Optional.ofNullable(dto.cores()).orElse(List.of())) {
            corRepository.findByNomeIgnoreCase(corNome)
                    .orElseGet(() -> corRepository.save(new Cor(corNome)));
        }

        for (String tamanhoNome : Optional.ofNullable(dto.tamanhos()).orElse(List.of())) {
            tamanhoRepository.findByNomeIgnoreCase(tamanhoNome)
                    .orElseGet(() -> tamanhoRepository.save(new Tamanho(tamanhoNome)));
        }
    }
    //produto com variação
    private void criarVariacoes(DadosCadastroProdutoRequestDTO dto, Produto produto) {
        for (DadosCadastroVariacaoRequestDTO v : dto.variacoes()) {
            var cor = corRepository.findByNomeIgnoreCase(v.cor())
                    .orElseThrow(() -> new RuntimeException("Cor não encontrada: " + v.cor()));
            var tamanho = tamanhoRepository.findByNomeIgnoreCase(v.tamanho())
                    .orElseThrow(() -> new RuntimeException("Tamanho não encontrado: " + v.tamanho()));

            var variacao = new Variacao(produto, cor, tamanho, v);
            variacaoRepository.save(variacao);
        }
    }

    public record ProdutoResponse(URI uri, DadosDetalhamentoProduto dados) {}

    //produto com variação
    public record ProdutoComVariacoesResponse(URI uri, DadosCadastroProdutoResponseDTO dados) {}

    //produto com variação
    public Page<DadosDetalhamentoVariacao> listarVariacoes(Long produtoId, Pageable pageable) {
        Produto produto = repository.getReferenceById(produtoId);
        List<DadosDetalhamentoVariacao> variacoes = produto.getVariacoes().stream()
                .map(DadosDetalhamentoVariacao::new)
                .toList();

        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), variacoes.size());
        List<DadosDetalhamentoVariacao> page = variacoes.subList(start, end);

        return new org.springframework.data.domain.PageImpl<>(page, pageable, variacoes.size());
    }

    //produto com variação
    public DadosDetalhamentoProdutoComVariacoes detalharComVariacoes(Long id) {
        Produto produto = repository.getReferenceById(id);
        return new DadosDetalhamentoProdutoComVariacoes(produto);
    }
    //produto com variação
    @Transactional
    public DadosDetalhamentoVariacao editarVariacao(Long variacaoId, DadosAtualizacaoVariacao dados) {
        Variacao variacao = variacaoRepository.getReferenceById(variacaoId);
        variacao.atualizar(dados);
        return new DadosDetalhamentoVariacao(variacao);
    }
}
