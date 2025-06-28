package com.catalogotech.pdp.domain.Cor;

import com.catalogotech.pdp.dto.cor.DadosAtualizacaoCor;
import com.catalogotech.pdp.dto.cor.DadosCadastroCor;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Table(name = "cores")
@NoArgsConstructor
@AllArgsConstructor
public class Cor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    private Boolean ativo=true;

    public Cor(DadosCadastroCor dados) {
        this.nome = dados.nome();
        this.ativo = true;
    }

    public void atualizar(DadosAtualizacaoCor dados) {
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

    public Cor(Long id) {
        this.id = id;
    }
    public Cor(String nome) {
        this.nome = nome;
    }
   
}
