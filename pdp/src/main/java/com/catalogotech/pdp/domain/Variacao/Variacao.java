package com.catalogotech.pdp.domain.Variacao;

import com.catalogotech.pdp.domain.Cor.Cor;
import com.catalogotech.pdp.domain.Produto.Produto;
import com.catalogotech.pdp.domain.Tamanho.Tamanho;
import com.catalogotech.pdp.dto.Variacao.DadosAtualizacaoVariacao;
import com.catalogotech.pdp.dto.Variacao.DadosCadastroVariacao;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Data
@Table(name = "variacoes")
@NoArgsConstructor
@AllArgsConstructor
public class Variacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer quantidade;
    private BigDecimal valorVenda;
    private BigDecimal valorCompra;
    private BigDecimal valorAtacado;
    private BigDecimal lucro;
    private String sku;
    private Integer nivelEstoque;

    @ManyToOne
    @JoinColumn(name = "produto_id")
    private Produto produto;

    @ManyToOne
    @JoinColumn(name = "cor_id")
    private Cor cor;

    @ManyToOne
    @JoinColumn(name = "tamanho_id")
    private Tamanho tamanho;

    private Boolean ativo;

    public Variacao(DadosCadastroVariacao dados) {
        this.produto = new Produto(dados.produtoId());
        this.cor = new Cor(dados.corId());
        this.tamanho = new Tamanho(dados.tamanhoId());
        this.quantidade = dados.quantidade();
        this.valorVenda = dados.valorVenda();
        this.valorCompra = dados.valorCompra();
        this.nivelEstoque = dados.nivelEstoque();
        this.valorAtacado = dados.valorAtacado();
        this.lucro = dados.lucro();
        this.sku = dados.sku();
        this.ativo = true;
    }


    public void atualizar(DadosAtualizacaoVariacao dados) {
        if (dados.quantidade() != null) this.quantidade = dados.quantidade();
        if (dados.valorVenda() != null) this.valorVenda = dados.valorVenda();
        if (dados.valorCompra() != null) this.valorCompra = dados.valorCompra();
        if (dados.nivelEstoque() != null) this.nivelEstoque = dados.nivelEstoque();
        if (dados.valorAtacado() != null) this.valorAtacado = dados.valorAtacado();
        if (dados.lucro() != null) this.lucro = dados.lucro();
        if (dados.sku() != null) this.sku = dados.sku();
    }
    public void excluir() {
        this.ativo = false;
    }
}
