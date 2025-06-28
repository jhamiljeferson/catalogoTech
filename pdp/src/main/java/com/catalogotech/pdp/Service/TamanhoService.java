package com.catalogotech.pdp.Service;

import com.catalogotech.pdp.Repository.TamanhoRepository;
import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import com.catalogotech.pdp.dto.tamanho.DadosAtualizacaoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosCadastroTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosDetalhamentoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosListagemTamanho;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TamanhoService {

    private final TamanhoRepository repository;

    @Transactional
    public TamanhoResponse cadastrar(DadosCadastroTamanho dados, UriComponentsBuilder uriBuilder) {
        // Procura por um tamanho com o mesmo nome (ignorando case)
        var tamanhoExistente = repository.findByNomeIgnoreCase(dados.nome());
        
        Tamanho tamanho;
        if (tamanhoExistente.isPresent()) {
            tamanho = tamanhoExistente.get();
            // Se o tamanho existe mas está inativo, reativa
            if (!tamanho.getAtivo()) {
                tamanho.ativar();
                tamanho = repository.save(tamanho);
            }
        } else {
            // Se não existe, cria um novo
            tamanho = new Tamanho(dados);
            tamanho = repository.save(tamanho);
        }
        
        var uri = uriBuilder.path("/tamanhos/{id}").buildAndExpand(tamanho.getId()).toUri();
        return new TamanhoResponse(uri, new DadosDetalhamentoTamanho(tamanho));
    }

    public Page<DadosListagemTamanho> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrue(paginacao).map(DadosListagemTamanho::new);
    }

    public List<DadosListagemTamanho> buscarPorNome(String nome) {
        return repository.findByNomeContainingIgnoreCaseAndAtivoTrue(nome)
                .stream()
                .map(DadosListagemTamanho::new)
                .toList();
    }

    @Transactional
    public DadosDetalhamentoTamanho atualizar(Long id, DadosAtualizacaoTamanho dados) {
        var tamanho = repository.findById(id).orElseThrow(() -> new EntityNotFoundException("Tamanho não encontrado"));
        
        // Verifica se já existe outro tamanho com o mesmo nome
        var tamanhoExistente = repository.findByNomeIgnoreCase(dados.nome());
        if (tamanhoExistente.isPresent() && !tamanhoExistente.get().getId().equals(id)) {
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Já existe um tamanho com o nome '" + dados.nome() + "'"
            );
        }
        
        tamanho.atualizar(dados);
        return new DadosDetalhamentoTamanho(tamanho);
    }

    public DadosDetalhamentoTamanho detalhar(Long id) {
        var tamanho = repository.findById(id).orElseThrow(() -> new EntityNotFoundException("Tamanho não encontrado"));
        return new DadosDetalhamentoTamanho(tamanho);
    }

    @Transactional
    public void excluir(Long id) {
        var tamanho = repository.findById(id).orElseThrow(() -> new EntityNotFoundException("Tamanho não encontrado"));
        
        if (repository.existeVariacaoAtiva(id)) {
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Tamanho não pode ser desativado pois está sendo utilizado em produtos ativos"
            );
        }
        
        tamanho.excluir();
    }

    public record TamanhoResponse(java.net.URI uri, DadosDetalhamentoTamanho dados) {}
}