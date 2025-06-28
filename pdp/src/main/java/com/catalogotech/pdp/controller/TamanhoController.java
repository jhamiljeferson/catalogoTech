package com.catalogotech.pdp.controller;

import com.catalogotech.pdp.Service.TamanhoService;
import com.catalogotech.pdp.dto.tamanho.DadosAtualizacaoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosCadastroTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosDetalhamentoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosListagemTamanho;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.List;

@RestController
@RequestMapping("tamanhos")
//@SecurityRequirement(name = "bearer-key")
@RequiredArgsConstructor
public class TamanhoController {

    private final TamanhoService service;

    @PostMapping
    public ResponseEntity cadastrar(@RequestBody @Valid DadosCadastroTamanho dados, UriComponentsBuilder uriBuilder) {
        var response = service.cadastrar(dados, uriBuilder);
        return ResponseEntity.created(response.uri()).body(response.dados());
    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemTamanho>> listar(@PageableDefault(size = 10, sort = {"nome"}) Pageable paginacao) {
        var page = service.listar(paginacao);
        return ResponseEntity.ok(page);
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<DadosListagemTamanho>> buscarPorNome(@RequestParam String nome) {
        var tamanhos = service.buscarPorNome(nome);
        return ResponseEntity.ok(tamanhos);
    }

    @PutMapping("/{id}")
    public ResponseEntity<DadosDetalhamentoTamanho> atualizar(@PathVariable Long id, @RequestBody @Valid DadosAtualizacaoTamanho dados) {
        var tamanho = service.atualizar(id, dados);
        return ResponseEntity.ok(tamanho);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable Long id) {
        service.excluir(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<DadosDetalhamentoTamanho> detalhar(@PathVariable Long id) {
        var tamanho = service.detalhar(id);
        return ResponseEntity.ok(tamanho);
    }
}
