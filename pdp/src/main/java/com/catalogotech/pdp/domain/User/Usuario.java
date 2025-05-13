package com.catalogotech.pdp.domain.User;

import com.catalogotech.pdp.domain.cargos.Cargos;
import com.catalogotech.pdp.domain.role.Role;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.time.LocalDate;

@Entity
@Data
@Table(name = "usuarios")
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String telefone;
    private String cpf;
    private String email;
    private String senha;
    private String endereco;
    private Boolean ativo;

    @ManyToOne
    @JoinColumn(name = "cargo_id") // nome da FK na tabela 'usuarios'
    private Cargos cargos;

    private LocalDate data = LocalDate.now();

    @Enumerated(EnumType.STRING)
    private Role role;

}
