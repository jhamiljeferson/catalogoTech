package com.catalogotech.pdp.Service;


import com.catalogotech.pdp.Repository.TamanhoRepository;
import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import com.catalogotech.pdp.dto.tamanho.DadosAtualizacaoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosCadastroTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosDetalhamentoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosListagemTamanho;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;

@Service
public class TamanhoService {

    @Autowired
    private TamanhoRepository repository;

    public TamanhoResponse cadastrar(@Valid DadosCadastroTamanho dados, UriComponentsBuilder uriBuilder) {
        var tamanho = new Tamanho(dados);
        repository.save(tamanho);
        URI uri = uriBuilder.path("/tamanhos/{id}").buildAndExpand(tamanho.getId()).toUri();
        return new TamanhoResponse(uri, new DadosDetalhamentoTamanho(tamanho));
    }

    public Page<DadosListagemTamanho> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrue().stream()
                .map(DadosListagemTamanho::new)
                .collect(java.util.stream.Collectors.collectingAndThen(
                        java.util.stream.Collectors.toList(),
                        list -> new PageImpl<>(list, paginacao, list.size())));
    }

    public DadosDetalhamentoTamanho detalhar(Long id) {
        var tamanho = repository.getReferenceById(id);
        return new DadosDetalhamentoTamanho(tamanho);
    }

    public DadosDetalhamentoTamanho atualizar(Long id,@Valid DadosAtualizacaoTamanho dados) {
        var tamanho = repository.getReferenceById(id);
        tamanho.atualizar(dados);
        return new DadosDetalhamentoTamanho(tamanho);
    }

    public void excluir(Long id) {
        var tamanho = repository.getReferenceById(id);
        tamanho.excluir();
    }

    public record TamanhoResponse(URI uri, DadosDetalhamentoTamanho dados) {}
}