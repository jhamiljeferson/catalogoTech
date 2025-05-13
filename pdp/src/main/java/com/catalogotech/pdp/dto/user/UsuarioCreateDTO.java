package com.catalogotech.pdp.dto.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UsuarioCreateDTO {
    @NotBlank
    private String nome;

    @NotBlank
    private String telefone;

    @NotBlank
    private String cpf;

    @Email
    private String email;

    @NotBlank
    private String senha;

    @NotBlank
    private String endereco;

    private Boolean ativo;

    private Long cargoId;

    private String role;
}

