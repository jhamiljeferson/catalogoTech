package com.catalogotech.pdp.Service;


import com.catalogotech.pdp.Repository.CategoriaRepository;
import com.catalogotech.pdp.domain.Categoria.Categoria;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosAtualizacaoCategoria;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosCadastroCategoria;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosDetalhamentoCategoria;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosListagemCategoria;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class CategoriaService {

    @Autowired
    private CategoriaRepository repository;

    @Transactional
    public CategoriaResponse cadastrar(@Valid DadosCadastroCategoria dados, UriComponentsBuilder uriBuilder) {
        var categoria = new Categoria(dados);
        repository.save(categoria);

        var uri = uriBuilder.path("/categorias/{id}").buildAndExpand(categoria.getId()).toUri();
        var dadosDetalhamento = new DadosDetalhamentoCategoria(categoria);

        return new CategoriaResponse(uri, dadosDetalhamento);
    }

    public Page<DadosListagemCategoria> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrue(paginacao).map(DadosListagemCategoria::new);
    }

    @Transactional
    public DadosDetalhamentoCategoria atualizar(Long id, @Valid DadosAtualizacaoCategoria dados) {
        var categoria = repository.getReferenceById(id);
        categoria.atualizarInformacoes(dados);
        return new DadosDetalhamentoCategoria(categoria);
    }

    @Transactional
    public void excluir(Long id) {
        var categoria = repository.getReferenceById(id);
        categoria.excluir();
    }

    public DadosDetalhamentoCategoria detalhar(Long id) {
        var categoria = repository.getReferenceById(id);
        return new DadosDetalhamentoCategoria(categoria);
    }

    public record CategoriaResponse(java.net.URI uri, DadosDetalhamentoCategoria dados) {}
}