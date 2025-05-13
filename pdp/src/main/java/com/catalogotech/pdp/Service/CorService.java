package com.catalogotech.pdp.Service;

import com.catalogotech.pdp.Repository.CorRepository;
import com.catalogotech.pdp.domain.Cor.Cor;
import com.catalogotech.pdp.dto.cor.DadosAtualizacaoCor;
import com.catalogotech.pdp.dto.cor.DadosCadastroCor;
import com.catalogotech.pdp.dto.cor.DadosDetalhamentoCor;
import com.catalogotech.pdp.dto.cor.DadosListagemCor;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;

@Service
public class CorService {

    @Autowired
    private CorRepository repository;

    public CorResponse cadastrar(@Valid DadosCadastroCor dados, UriComponentsBuilder uriBuilder) {
        var cor = new Cor(dados);
        repository.save(cor);
        URI uri = uriBuilder.path("/cores/{id}").buildAndExpand(cor.getId()).toUri();
        return new CorResponse(uri, new DadosDetalhamentoCor(cor));
    }

    public Page<DadosListagemCor> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrue().stream()
                .map(DadosListagemCor::new)
                .collect(java.util.stream.Collectors.collectingAndThen(
                        java.util.stream.Collectors.toList(),
                        list -> new org.springframework.data.domain.PageImpl<>(list, paginacao, list.size())));
    }

    public DadosDetalhamentoCor detalhar(Long id) {
        var cor = repository.getReferenceById(id);
        return new DadosDetalhamentoCor(cor);
    }

    public DadosDetalhamentoCor atualizar(Long id,@Valid DadosAtualizacaoCor dados) {
        var cor = repository.getReferenceById(id);
        cor.atualizar(dados);
        return new DadosDetalhamentoCor(cor);
    }

    public void excluir(Long id) {
        var cor = repository.getReferenceById(id);
        cor.excluir();
    }

    public record CorResponse(URI uri, DadosDetalhamentoCor dados) {}
}
