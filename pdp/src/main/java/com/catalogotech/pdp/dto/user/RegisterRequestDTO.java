package com.catalogotech.pdp.dto.user;

public record RegisterRequestDTO (
        String nome,
        String email,
        String senha,
        Long cargoId,
        String role
) { }