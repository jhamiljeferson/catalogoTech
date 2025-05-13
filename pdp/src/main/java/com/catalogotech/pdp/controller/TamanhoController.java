package com.catalogotech.pdp.controller;

import com.catalogotech.pdp.Service.TamanhoService;
import com.catalogotech.pdp.dto.tamanho.DadosAtualizacaoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosCadastroTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosDetalhamentoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosListagemTamanho;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

@RestController
@RequestMapping("/tamanhos")
//@SecurityRequirement(name = "bearer-key")
public class TamanhoController {

    @Autowired
    private TamanhoService service;

    @PostMapping
    @Transactional
    public ResponseEntity<?> cadastrar(@RequestBody @Valid DadosCadastroTamanho dados, UriComponentsBuilder uriBuilder) {
        var response = service.cadastrar(dados, uriBuilder);
        return ResponseEntity.created(response.uri()).body(response.dados());
    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemTamanho>> listar(@PageableDefault(size = 10, sort = {"nome"}) Pageable paginacao) {
        return ResponseEntity.ok(service.listar(paginacao));
    }

    @GetMapping("/{id}")
    public ResponseEntity<DadosDetalhamentoTamanho> detalhar(@PathVariable Long id) {
        return ResponseEntity.ok(service.detalhar(id));
    }

    @PutMapping("/{id}")
    @Transactional
    public ResponseEntity<DadosDetalhamentoTamanho> atualizar(@PathVariable Long id,@RequestBody @Valid DadosAtualizacaoTamanho dados) {
        return ResponseEntity.ok(service.atualizar(id,dados));
    }

    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity<Void> excluir(@PathVariable Long id) {
        service.excluir(id);
        return ResponseEntity.noContent().build();
    }
}
