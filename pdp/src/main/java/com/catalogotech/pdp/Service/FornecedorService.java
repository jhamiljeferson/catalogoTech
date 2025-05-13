package com.catalogotech.pdp.Service;

import com.catalogotech.pdp.Repository.FornecedorRepository;
import com.catalogotech.pdp.domain.Fornecedor.Fornecedor;
import com.catalogotech.pdp.dto.fornecedor.DadosAtualizacaoFornecedor;
import com.catalogotech.pdp.dto.fornecedor.DadosCadastroFornecedor;
import com.catalogotech.pdp.dto.fornecedor.DadosDetalhamentoFornecedor;
import com.catalogotech.pdp.dto.fornecedor.DadosListagemFornecedor;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class FornecedorService {

    @Autowired
    private FornecedorRepository repository;

    public FornecedorResponse cadastrar(@Valid DadosCadastroFornecedor dados, UriComponentsBuilder uriBuilder) {
        var fornecedor = new Fornecedor(dados);
        repository.save(fornecedor);
        var uri = uriBuilder.path("/fornecedores/{id}").buildAndExpand(fornecedor.getId()).toUri();
        var dadosDetalhamento = new DadosDetalhamentoFornecedor(fornecedor);
        return new FornecedorResponse(uri, dadosDetalhamento);
    }

    public Page<DadosListagemFornecedor> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrue(paginacao).map(DadosListagemFornecedor::new);
    }

    public DadosDetalhamentoFornecedor atualizar(Long id,@Valid DadosAtualizacaoFornecedor dados) {
        var fornecedor = repository.getReferenceById(id);
        fornecedor.atualizarInformacoes(dados);
        return new DadosDetalhamentoFornecedor(fornecedor);
    }

    public void excluir(Long id) {
        var fornecedor = repository.getReferenceById(id);
        fornecedor.excluir();
    }

    public DadosDetalhamentoFornecedor detalhar(Long id) {
        var fornecedor = repository.getReferenceById(id);
        return new DadosDetalhamentoFornecedor(fornecedor);
    }

    public record FornecedorResponse(java.net.URI uri, DadosDetalhamentoFornecedor dados) {}
}
