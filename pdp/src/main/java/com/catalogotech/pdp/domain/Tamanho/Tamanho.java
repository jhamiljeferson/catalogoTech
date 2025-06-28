package com.catalogotech.pdp.domain.Tamanho;

import com.catalogotech.pdp.dto.tamanho.DadosAtualizacaoTamanho;
import com.catalogotech.pdp.dto.tamanho.DadosCadastroTamanho;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Table(name = "tamanhos")
@NoArgsConstructor
@AllArgsConstructor
public class Tamanho {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    private Boolean ativo=true;

    public Tamanho(DadosCadastroTamanho dados) {
        this.nome = dados.nome();
        this.ativo = true;
    }

    public void atualizar(DadosAtualizacaoTamanho dados) {
        if (dados.nome() != null && !dados.nome().isBlank()) {
            this.nome = dados.nome();
        }
    }

    public void excluir() {
        this.ativo = false;
    }

    public void ativar() {
        this.ativo = true;
    }

    public Tamanho(Long id) {
        this.id = id;
    }
    
    public Tamanho(String nome) {
        this.nome = nome;
    }
}
