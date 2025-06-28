package com.catalogotech.pdp.controller;


import com.catalogotech.pdp.Service.CategoriaService;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosAtualizacaoCategoria;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosCadastroCategoria;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosListagemCategoria;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

@RestController
@RequestMapping("/categorias")
//@SecurityRequirement(name = "bearer-key")
public class CategoriaController {

    @Autowired
    private CategoriaService service;

    @PostMapping
    public ResponseEntity cadastrar(@RequestBody @Valid DadosCadastroCategoria dados, UriComponentsBuilder uriBuilder) {
        var categoria = service.cadastrar(dados, uriBuilder);
        return ResponseEntity.created(categoria.uri()).body(categoria.dados());

    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemCategoria>> listar(@PageableDefault(size = 10, sort = "nome") Pageable pageable) {
        Page<DadosListagemCategoria> resultado = service.listar(pageable);

        resultado.getContent().forEach(System.out::println);
        return ResponseEntity.ok(service.listar(pageable));
    }

    @PutMapping("/{id}")
    public ResponseEntity atualizar(@PathVariable Long id, @RequestBody @Valid DadosAtualizacaoCategoria dados) {
        var categoria = service.atualizar(id, dados);
        return ResponseEntity.ok(categoria);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity excluir(@PathVariable Long id) {
        service.excluir(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity detalhar(@PathVariable Long id) {
        return ResponseEntity.ok(service.detalhar(id));
    }
}