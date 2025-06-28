package com.catalogotech.pdp.controller;

import com.catalogotech.pdp.Service.ProdutoService;
import com.catalogotech.pdp.dto.Variacao.DadosAtualizacaoVariacao;
import com.catalogotech.pdp.dto.Variacao.DadosDetalhamentoProdutoComVariacoes;
import com.catalogotech.pdp.dto.produto.DadosCadastroProdutoRequestDTO;
import com.catalogotech.pdp.dto.produto.DadosCadastroProduto;
import com.catalogotech.pdp.dto.produto.DadosAtualizacaoProduto;
import com.catalogotech.pdp.dto.produto.DadosListagemProduto;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import com.catalogotech.pdp.dto.Variacao.DadosDetalhamentoVariacao;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/produtos")
//@SecurityRequirement(name = "bearer-key")
public class ProdutoController {

    @Autowired
    private ProdutoService service;

    @PostMapping
    @Transactional
    public ResponseEntity cadastrar(@RequestBody @Valid DadosCadastroProduto dados, UriComponentsBuilder uriBuilder) {
        var response = service.cadastrar(dados, uriBuilder);
        return ResponseEntity.created(response.uri()).body(response.dados());
    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemProduto>> listar(@PageableDefault(size = 10, sort = "nome") Pageable paginacao) {
        Page<DadosListagemProduto> resultado = service.listar(paginacao);
        resultado.getContent().forEach(System.out::println);
        return ResponseEntity.ok(service.listar(paginacao));
    }

    @GetMapping("/{id}")
    public ResponseEntity detalhar(@PathVariable Long id) {
        return ResponseEntity.ok(service.detalhar(id));
    }

    @PutMapping("/{id}")
    @Transactional
    public ResponseEntity atualizar(@PathVariable Long id, @RequestBody @Valid DadosAtualizacaoProduto dados) {
        return ResponseEntity.ok(service.atualizar(id, dados));
    }

    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity excluir(@PathVariable Long id) {
        service.excluir(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/buscar")
    public ResponseEntity<Page<DadosListagemProduto>> buscarPorNome(
            @RequestParam String nome,
            @PageableDefault(size = 10, sort = "nome") Pageable pageable) {
        return ResponseEntity.ok(service.buscarPorNome(nome, pageable));
    }

    //produto com variação CADASTRAR
    @PostMapping("/variacao")
    @Transactional
    public ResponseEntity cadastrarVariacao(@RequestBody @Valid DadosCadastroProdutoRequestDTO dto, UriComponentsBuilder uriBuilder) {
        var response = service.cadastrarVariacao(dto, uriBuilder);
        return ResponseEntity.created(response.uri()).body(response.dados());
    }

    //produto com variação LISTAR
    @GetMapping("/{id}/variacoes")
    public ResponseEntity<Page<DadosDetalhamentoVariacao>> listarVariacoes(
            @PathVariable Long id,
            @PageableDefault(size = 10, sort = "id") Pageable paginacao) {
        return ResponseEntity.ok(service.listarVariacoes(id, paginacao));
    }

    //produto com variação DETALHAR
    @GetMapping("/{id}/detalhe-com-variacoes")
    public ResponseEntity<DadosDetalhamentoProdutoComVariacoes> detalharComVariacoes(@PathVariable Long id) {
        return ResponseEntity.ok(service.detalharComVariacoes(id));
    }

    //produto com variação EDITAR
    @PutMapping("/variacoes/{variacaoId}")
    @Transactional
    public ResponseEntity<DadosDetalhamentoVariacao> editarVariacao(
            @PathVariable Long variacaoId,
            @RequestBody @Valid DadosAtualizacaoVariacao dados
    ) {
        return ResponseEntity.ok(service.editarVariacao(variacaoId, dados));
    }
}
