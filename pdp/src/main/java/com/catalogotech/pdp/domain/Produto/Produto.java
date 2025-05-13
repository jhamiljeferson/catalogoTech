package com.catalogotech.pdp.domain.Produto;

import com.catalogotech.pdp.domain.Categoria.Categoria;
import com.catalogotech.pdp.domain.Fornecedor.Fornecedor;
import com.catalogotech.pdp.domain.Variacao.Variacao;
import com.catalogotech.pdp.dto.produto.DadosAtualizacaoProduto;
import com.catalogotech.pdp.dto.produto.DadosCadastroProduto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Table(name = "produtos")
@NoArgsConstructor
@AllArgsConstructor
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String codigo;
    private String nome;
    private String descricao;
    private String foto;
    private LocalDate data;
    private Boolean ativo;

    @ManyToOne
    @JoinColumn(name = "categoria_id")
    private Categoria categoria;

    @ManyToOne
    @JoinColumn(name = "fornecedor_id")
    private Fornecedor fornecedor;

    @OneToMany(mappedBy = "produto", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Variacao> variacoes = new ArrayList<>();

    public Produto(DadosCadastroProduto dados, Categoria categoria, Fornecedor fornecedor) {
        this.codigo = dados.codigo();
        this.nome = dados.nome();
        this.descricao = dados.descricao();
        this.foto = dados.foto();
        this.categoria = categoria;
        this.fornecedor = fornecedor;
        this.data = LocalDate.now();
        this.ativo = true;
    }

    public void atualizar(DadosAtualizacaoProduto dados, Categoria categoria, Fornecedor fornecedor) {
        if (dados.nome() != null && !dados.nome().isBlank()) this.nome = dados.nome();
        if (dados.descricao() != null) this.descricao = dados.descricao();
        if (dados.foto() != null) this.foto = dados.foto();
        if (categoria != null) this.categoria = categoria;
        if (fornecedor != null) this.fornecedor = fornecedor;
    }
    public Produto(Long id) {
        this.id = id;
    }
    public void excluir() {
        this.ativo = false;
    }
}
