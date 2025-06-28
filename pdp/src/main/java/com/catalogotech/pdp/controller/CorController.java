package com.catalogotech.pdp.controller;

import com.catalogotech.pdp.Service.CorService;
import com.catalogotech.pdp.dto.cor.DadosAtualizacaoCor;
import com.catalogotech.pdp.dto.cor.DadosCadastroCor;
import com.catalogotech.pdp.dto.cor.DadosDetalhamentoCor;
import com.catalogotech.pdp.dto.cor.DadosListagemCor;
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
@RequestMapping("cores")
//@SecurityRequirement(name = "bearer-key")
@RequiredArgsConstructor
public class CorController {

    private final CorService service;

    @PostMapping
    public ResponseEntity cadastrar(@RequestBody @Valid DadosCadastroCor dados, UriComponentsBuilder uriBuilder) {
        var response = service.cadastrar(dados, uriBuilder);
        return ResponseEntity.created(response.uri()).body(response.dados());
    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemCor>> listar(@PageableDefault(size = 10, sort = {"nome"}) Pageable paginacao) {
        var page = service.listar(paginacao);
        return ResponseEntity.ok(page);
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<DadosListagemCor>> buscarPorNome(@RequestParam String nome) {
        var cores = service.buscarPorNome(nome);
        return ResponseEntity.ok(cores);
    }

    @PutMapping("/{id}")
    public ResponseEntity<DadosDetalhamentoCor> atualizar(@PathVariable Long id, @RequestBody @Valid DadosAtualizacaoCor dados) {
        var cor = service.atualizar(id, dados);
        return ResponseEntity.ok(cor);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable Long id) {
        service.excluir(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<DadosDetalhamentoCor> detalhar(@PathVariable Long id) {
        var cor = service.detalhar(id);
        return ResponseEntity.ok(cor);
    }
}
