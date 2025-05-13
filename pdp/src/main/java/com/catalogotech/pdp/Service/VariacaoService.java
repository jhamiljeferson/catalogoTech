package com.catalogotech.pdp.Service;


import com.catalogotech.pdp.Repository.VariacaoRepository;
import com.catalogotech.pdp.domain.Variacao.Variacao;
import com.catalogotech.pdp.dto.Variacao.DadosAtualizacaoVariacao;
import com.catalogotech.pdp.dto.Variacao.DadosCadastroVariacao;
import com.catalogotech.pdp.dto.Variacao.DadosDetalhamentoVariacao;
import com.catalogotech.pdp.dto.Variacao.DadosListagemVariacao;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class VariacaoService {

    @Autowired
    private VariacaoRepository repository;

    public VariacaoResponse cadastrar(@Valid DadosCadastroVariacao dados, UriComponentsBuilder uriBuilder) {
        var variacao = new Variacao(dados);
        repository.save(variacao);

        var uri = uriBuilder.path("/variacoes/{id}").buildAndExpand(variacao.getId()).toUri();
        var dadosDetalhamento = new DadosDetalhamentoVariacao(variacao);

        return new VariacaoResponse(uri, dadosDetalhamento);
    }

    public Page<DadosListagemVariacao> listar(Pageable pageable) {
        return repository.findAll(pageable).map(DadosListagemVariacao::new);
    }

    public DadosDetalhamentoVariacao atualizar(Long id,DadosAtualizacaoVariacao dados) {
        var variacao = repository.getReferenceById(id);
        variacao.atualizar(dados);
        return new DadosDetalhamentoVariacao(variacao);
    }

    public void excluir(Long id) {
        repository.deleteById(id);
    }

    public DadosDetalhamentoVariacao detalhar(Long id) {
        return new DadosDetalhamentoVariacao(repository.getReferenceById(id));
    }

    public record VariacaoResponse(java.net.URI uri, DadosDetalhamentoVariacao dados) {}
}
