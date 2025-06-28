package com.catalogotech.pdp.Service;

import com.catalogotech.pdp.Repository.CorRepository;
import com.catalogotech.pdp.domain.Cor.Cor;
import com.catalogotech.pdp.dto.cor.DadosAtualizacaoCor;
import com.catalogotech.pdp.dto.cor.DadosCadastroCor;
import com.catalogotech.pdp.dto.cor.DadosDetalhamentoCor;
import com.catalogotech.pdp.dto.cor.DadosListagemCor;
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
public class CorService {

    private final CorRepository repository;

    @Transactional
    public CorResponse cadastrar(DadosCadastroCor dados, UriComponentsBuilder uriBuilder) {
        // Procura por uma cor com o mesmo nome (ignorando case)
        var corExistente = repository.findByNomeIgnoreCase(dados.nome());
        
        Cor cor;
        if (corExistente.isPresent()) {
            cor = corExistente.get();
            // Se a cor existe mas está inativa, reativa
            if (!cor.getAtivo()) {
                cor.ativar();
                cor = repository.save(cor);
            }
        } else {
            // Se não existe, cria uma nova
            cor = new Cor(dados);
            cor = repository.save(cor);
        }
        
        var uri = uriBuilder.path("/cores/{id}").buildAndExpand(cor.getId()).toUri();
        return new CorResponse(uri, new DadosDetalhamentoCor(cor));
    }

    public Page<DadosListagemCor> listar(Pageable paginacao) {
        return repository.findAllByAtivoTrue(paginacao).map(DadosListagemCor::new);
    }

    public List<DadosListagemCor> buscarPorNome(String nome) {
        return repository.findByNomeContainingIgnoreCaseAndAtivoTrue(nome)
                .stream()
                .map(DadosListagemCor::new)
                .toList();
    }

    @Transactional
    public DadosDetalhamentoCor atualizar(Long id, DadosAtualizacaoCor dados) {
        var cor = repository.findById(id).orElseThrow(() -> new EntityNotFoundException("Cor não encontrada"));
        
        // Verifica se já existe outra cor com o mesmo nome
        var corExistente = repository.findByNomeIgnoreCase(dados.nome());
        if (corExistente.isPresent() && !corExistente.get().getId().equals(id)) {
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Já existe uma cor com o nome '" + dados.nome() + "'"
            );
        }
        
        cor.atualizar(dados);
        return new DadosDetalhamentoCor(cor);
    }

    public DadosDetalhamentoCor detalhar(Long id) {
        var cor = repository.findById(id).orElseThrow(() -> new EntityNotFoundException("Cor não encontrada"));
        return new DadosDetalhamentoCor(cor);
    }

    @Transactional
    public void excluir(Long id) {
        var cor = repository.findById(id).orElseThrow(() -> new EntityNotFoundException("Cor não encontrada"));
        
        if (repository.existeVariacaoAtiva(id)) {
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Cor não pode ser desativada pois está sendo utilizada em produtos ativos"
            );
        }
        
        cor.excluir();
    }

    public record CorResponse(java.net.URI uri, DadosDetalhamentoCor dados) {}
}
