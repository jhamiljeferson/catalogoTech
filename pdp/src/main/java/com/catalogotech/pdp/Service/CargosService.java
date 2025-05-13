package com.catalogotech.pdp.Service;


import com.catalogotech.pdp.Repository.CargosRepository;
import com.catalogotech.pdp.domain.cargos.Cargos;
import com.catalogotech.pdp.dto.cargos.CargosDTO;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;


@Service
public class CargosService {

    @Autowired
    private CargosRepository repository;

    @Transactional(readOnly = true)
    public List<CargosDTO> findAll() {
        List<Cargos> list = repository.findAll();
        return list.stream().map(CargosDTO::new).collect(Collectors.toList());
    }

    @Transactional
    public CargosDTO insert(CargosDTO dto) {
        Cargos entity = new Cargos();
        entity.setNome(dto.getNome());
        entity = repository.save(entity);
        return new CargosDTO(entity);
    }

    @Transactional(readOnly = true)
    public CargosDTO findById(Long id) {
        Cargos entity = repository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("Cargo não encontrado - id: " + id)
        );
        return new CargosDTO(entity);
    }

    @Transactional
    public CargosDTO update(Long id, CargosDTO dto) {
        try {
            Cargos entity = repository.getReferenceById(id);
            entity.setNome(dto.getNome());
            entity = repository.save(entity);
            return new CargosDTO(entity);
        } catch (EntityNotFoundException e) {
            throw new IllegalArgumentException("Cargo não encontrado");
        }
    }

    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new IllegalArgumentException("Cargo inválido - id: " + id);
        }
        try {
            repository.deleteById(id);
        } catch (Exception e) {
            throw new IllegalArgumentException("Erro ao deletar o cargo");
        }
    }
}