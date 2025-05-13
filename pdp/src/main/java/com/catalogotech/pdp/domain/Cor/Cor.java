package com.catalogotech.pdp.domain.Cor;

import com.catalogotech.pdp.domain.Produto.Produto;
import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import com.catalogotech.pdp.dto.cor.DadosAtualizacaoCor;
import com.catalogotech.pdp.dto.cor.DadosCadastroCor;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

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

    private Boolean ativo;

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
    public Cor(Long id) {
        this.id = id;
    }
    public Cor(String nome) {
        this.nome = nome;
    }
}
