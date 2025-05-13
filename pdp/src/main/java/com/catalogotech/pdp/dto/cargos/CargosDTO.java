package com.catalogotech.pdp.dto.cargos;

import com.catalogotech.pdp.domain.cargos.Cargos;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CargosDTO {
    private Long id;

    @NotBlank(message = "Nome é obrigatório")
    private String nome;

    public CargosDTO(Cargos entity) {
        this.id = entity.getId();
        this.nome = entity.getNome();
    }
}
