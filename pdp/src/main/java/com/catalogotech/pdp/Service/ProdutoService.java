package com.catalogotech.pdp.Service;


import com.catalogotech.pdp.Repository.*;
import com.catalogotech.pdp.domain.Categoria.Categoria;
import com.catalogotech.pdp.domain.Cor.Cor;
import com.catalogotech.pdp.domain.Fornecedor.Fornecedor;
import com.catalogotech.pdp.domain.Produto.Produto;
import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import com.catalogotech.pdp.domain.Variacao.Variacao;
import com.catalogotech.pdp.dto.Variacao.VariacaoRequestDTO;
import com.catalogotech.pdp.dto.produto.*;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.time.LocalDate;
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
    public void cadastrarVariacao(ProdutoRequestDTO dto) {
        var categoria = categoriaRepository.getReferenceById(dto.categoriaId());
        var fornecedor = fornecedorRepository.getReferenceById(dto.fornecedorId());

        Produto produto = new Produto();
        produto.setNome(dto.nome());
        produto.setDescricao(dto.descricao());
        produto.setCodigo(dto.codigo());
        produto.setFoto(dto.foto());
        produto.setCategoria(categoria);
        produto.setFornecedor(fornecedor);
        produto.setData(LocalDate.now());
        produto.setAtivo(true);

        repository.save(produto);

        for (String corNome : Optional.ofNullable(dto.cores()).orElse(List.of())) {
            corRepository.findByNomeIgnoreCase(corNome)
                    .orElseGet(() -> corRepository.save(new Cor(corNome)));
        }

        for (String tamanhoNome : Optional.ofNullable(dto.tamanhos()).orElse(List.of())) {
            tamanhoRepository.findByNomeIgnoreCase(tamanhoNome)
                    .orElseGet(() -> tamanhoRepository.save(new Tamanho(tamanhoNome)));
        }

        for (VariacaoRequestDTO v : dto.variacoes()) {
            var cor = corRepository.findByNomeIgnoreCase(v.cor())
                    .orElseThrow(() -> new RuntimeException("Cor não encontrada: " + v.cor()));
            var tamanho = tamanhoRepository.findByNomeIgnoreCase(v.tamanho())
                    .orElseThrow(() -> new RuntimeException("Tamanho não encontrado: " + v.tamanho()));

            Variacao variacao = new Variacao();
            variacao.setProduto(produto);
            variacao.setCor(cor);
            variacao.setTamanho(tamanho);
            variacao.setQuantidade(v.quantidade());
            variacao.setValorVenda(v.preco());
            variacao.setValorCompra(v.valorCompra());
            variacao.setValorAtacado(v.valorAtacado());
            variacao.setLucro(v.lucro());
            variacao.setSku(v.sku());

            variacaoRepository.save(variacao);
        }
    }

    public ProdutoResponse cadastrar(@Valid DadosCadastroProduto dados, UriComponentsBuilder uriBuilder) {
        var categoria = categoriaRepository.getReferenceById(dados.categoriaId());
        var fornecedor = fornecedorRepository.getReferenceById(dados.fornecedorId());

        var produto = new Produto(dados, categoria, fornecedor);
        repository.save(produto);

        URI uri = uriBuilder.path("/produtos/{id}").buildAndExpand(produto.getId()).toUri();
        return new ProdutoResponse(uri, new DadosDetalhamentoProduto(produto));
    }

    public Page<DadosListagemProduto> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrue().stream()
                .map(DadosListagemProduto::new)
                .collect(java.util.stream.Collectors.collectingAndThen(
                        java.util.stream.Collectors.toList(),
                        list -> new org.springframework.data.domain.PageImpl<>(list, paginacao, list.size())));
    }

    public DadosDetalhamentoProduto atualizar(@Valid DadosAtualizacaoProduto dados) {
        var produto = repository.getReferenceById(dados.id());

        Categoria categoria = dados.categoriaId() != null ? categoriaRepository.getReferenceById(dados.categoriaId()) : null;
        Fornecedor fornecedor = dados.fornecedorId() != null ? fornecedorRepository.getReferenceById(dados.fornecedorId()) : null;

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

    public record ProdutoResponse(URI uri, DadosDetalhamentoProduto dados) {}
}
