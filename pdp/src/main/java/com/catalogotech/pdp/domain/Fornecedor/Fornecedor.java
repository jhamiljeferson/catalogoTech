package com.catalogotech.pdp.domain.Fornecedor;

import com.catalogotech.pdp.domain.Produto.Produto;
import com.catalogotech.pdp.dto.fornecedor.DadosAtualizacaoFornecedor;
import com.catalogotech.pdp.dto.fornecedor.DadosCadastroFornecedor;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Entity
@Data
@Table(name = "fornecedores")
@NoArgsConstructor
@AllArgsConstructor
public class Fornecedor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;
    private String cpf;
    private String telefone;
    private String email;
    private String endereco;
    private LocalDate data;

    @Enumerated(EnumType.STRING)
    private TipoPessoa tipoPessoa;

    private Boolean ativo;

    @OneToMany(mappedBy = "fornecedor")
    private List<Produto> produtos;

    public Fornecedor(DadosCadastroFornecedor dados) {
        this.nome = dados.nome();
        this.cpf = dados.cpf();
        this.telefone = dados.telefone();
        this.email = dados.email();
        this.endereco = dados.endereco();
        this.data = LocalDate.now();
        this.tipoPessoa = dados.tipoPessoa();
        this.ativo = true;
    }

    public void atualizarInformacoes(DadosAtualizacaoFornecedor dados) {
        if (dados.nome() != null) this.nome = dados.nome();
        if (dados.telefone() != null) this.telefone = dados.telefone();
        if (dados.email() != null) this.email = dados.email();
        if (dados.endereco() != null) this.endereco = dados.endereco();
    }

    public void excluir() {
        this.ativo = false;
    }
}
