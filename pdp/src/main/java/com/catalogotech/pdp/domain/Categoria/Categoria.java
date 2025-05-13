package com.catalogotech.pdp.domain.Categoria;

import com.catalogotech.pdp.domain.Produto.Produto;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosAtualizacaoCategoria;
import com.catalogotech.pdp.dto.CategoriaDTO.DadosCadastroCategoria;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@Table(name = "categorias")
@NoArgsConstructor
@AllArgsConstructor
public class Categoria {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;
    private Boolean ativo;

    @OneToMany(mappedBy = "categoria")
    private List<Produto> produtos;

    public Categoria(DadosCadastroCategoria dados) {
        this.nome = dados.nome();
        this.ativo = true;
    }

    public void atualizarInformacoes(DadosAtualizacaoCategoria dados) {
        if (dados.nome() != null) {
            this.nome = dados.nome();
        }
    }

    public void excluir() {
        this.ativo = false;
    }
}
