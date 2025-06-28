package com.catalogotech.pdp.controller;

/*
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

@RestController
@RequestMapping("/variacoes")
//@SecurityRequirement(name = "bearer-key")
public class VariacaoController {

    @Autowired
    private VariacaoService service;

    @PostMapping
    @Transactional
    public ResponseEntity cadastrar(@RequestBody @Valid DadosCadastroVariacao dados, UriComponentsBuilder uriBuilder) {
        var response = service.cadastrar(dados, uriBuilder);
        return ResponseEntity.created(response.uri()).body(response.dados());
    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemVariacao>> listar(@PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(service.listar(pageable));
    }

    @PutMapping("/{id}")
    @Transactional
    public ResponseEntity atualizar(@PathVariable Long id, @RequestBody @Valid DadosAtualizacaoVariacao dados) {
        return ResponseEntity.ok(service.atualizar(id,dados));
    }

    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity excluir(@PathVariable Long id) {
        service.excluir(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity detalhar(@PathVariable Long id) {
        return ResponseEntity.ok(service.detalhar(id));
    }


}
*/