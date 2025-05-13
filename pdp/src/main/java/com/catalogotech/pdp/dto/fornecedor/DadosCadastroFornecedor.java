package com.catalogotech.pdp.dto.fornecedor;

import com.catalogotech.pdp.domain.Fornecedor.TipoPessoa;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

import java.time.LocalDate;

public record DadosCadastroFornecedor(
        @NotBlank(message = "Nome é obrigatório")
        String nome,

        @NotBlank(message = "CPF é obrigatório")
        @Pattern(regexp = "\\d{11}", message = "CPF deve conter 11 dígitos")
        String cpf,

        @NotBlank(message = "Telefone é obrigatório")
        String telefone,

        @NotBlank(message = "Email é obrigatório")
        @Email(message = "Formato de e-mail inválido")
        String email,

        @NotBlank(message = "Endereço é obrigatório")
        String endereco,

        @NotNull(message = "Data é obrigatória")
        LocalDate data,

        @NotNull(message = "Tipo de pessoa é obrigatório")
        TipoPessoa tipoPessoa
) {}