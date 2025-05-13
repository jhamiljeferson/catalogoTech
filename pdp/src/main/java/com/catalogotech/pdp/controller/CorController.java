package com.catalogotech.pdp.controller;

import com.catalogotech.pdp.Service.CorService;
import com.catalogotech.pdp.dto.cor.DadosAtualizacaoCor;
import com.catalogotech.pdp.dto.cor.DadosCadastroCor;
import com.catalogotech.pdp.dto.cor.DadosDetalhamentoCor;
import com.catalogotech.pdp.dto.cor.DadosListagemCor;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

@RestController
@RequestMapping("/cores")
//@SecurityRequirement(name = "bearer-key")
public class CorController {

    @Autowired
    private CorService service;

    @PostMapping
    @Transactional
    public ResponseEntity<?> cadastrar(@RequestBody @Valid DadosCadastroCor dados, UriComponentsBuilder uriBuilder) {
        var response = service.cadastrar(dados, uriBuilder);
        return ResponseEntity.created(response.uri()).body(response.dados());
    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemCor>> listar(@PageableDefault(size = 10, sort = {"nome"}) Pageable paginacao) {
        return ResponseEntity.ok(service.listar(paginacao));
    }

    @GetMapping("/{id}")
    public ResponseEntity<DadosDetalhamentoCor> detalhar(@PathVariable Long id) {
        return ResponseEntity.ok(service.detalhar(id));
    }

    @PutMapping("/{id}")
    @Transactional
    public ResponseEntity<DadosDetalhamentoCor> atualizar(@PathVariable Long id,@RequestBody @Valid DadosAtualizacaoCor dados) {
        return ResponseEntity.ok(service.atualizar(id,dados));
    }

    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity<Void> excluir(@PathVariable Long id) {
        service.excluir(id);
        return ResponseEntity.noContent().build();
    }
}
