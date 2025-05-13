package com.catalogotech.pdp.dto.user;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioDTO {
    private Long id;
    private String nome;
    private String telefone;
    private String cpf;
    private String email;
    private String endereco;
    private Boolean ativo;
    private String cargoNome;
    private String role;
    private LocalDate data;

}
