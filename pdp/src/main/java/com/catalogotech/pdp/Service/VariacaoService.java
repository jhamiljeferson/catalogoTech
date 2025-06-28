package com.catalogotech.pdp.Service;


import com.catalogotech.pdp.Repository.VariacaoRepository;
import com.catalogotech.pdp.domain.Variacao.Variacao;
import com.catalogotech.pdp.dto.Variacao.DadosCadastroVariacao;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;
/*
@Service
public class VariacaoService {

    @Autowired
    private VariacaoRepository repository;

    public VariacaoResponse cadastrar(@Valid DadosCadastroVariacao dados, UriComponentsBuilder uriBuilder) {
        var variacao = new Variacao(dados);
        repository.save(variacao);

        var uri = uriBuilder.path("/variacoes/{id}").buildAndExpand(variacao.getId()).toUri();
        var dadosDetalhamento = new DadosCadastroVariacao.DadosDetalhamentoVariacao(variacao);

        return new VariacaoResponse(uri, dadosDetalhamento);
    }

    public Page<DadosCadastroVariacao.DadosListagemVariacao> listar(Pageable pageable) {
        return repository.findAll(pageable).map(DadosCadastroVariacao.DadosListagemVariacao::new);
    }

    public DadosCadastroVariacao.DadosDetalhamentoVariacao atualizar(Long id, DadosAtualizacaoVariacao dados) {
        var variacao = repository.getReferenceById(id);
        variacao.atualizar(dados);
        return new DadosCadastroVariacao.DadosDetalhamentoVariacao(variacao);
    }

    public void excluir(Long id) {
        repository.deleteById(id);
    }

    public DadosCadastroVariacao.DadosDetalhamentoVariacao detalhar(Long id) {
        return new DadosCadastroVariacao.DadosDetalhamentoVariacao(repository.getReferenceById(id));
    }

    public record VariacaoResponse(java.net.URI uri, DadosCadastroVariacao.DadosDetalhamentoVariacao dados) {}

}
 */
